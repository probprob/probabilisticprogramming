import React from "react";
import {
  Button,
  Checkbox,
  Table,
  TableBody,
  TableCell,
  TableRow,
  TextField,
} from "@material-ui/core";

import { useState, useMemo, useRef } from "react";

//Production Build mit Cache: 5000 Positionen noch OK - Speicher 80% von 8GB
//Production Build ohne Cache: 5000 Positionen reagiert nicht - 100% Speicher und CPU
//Production Build ohne Cache: 500 Positionen reagiert sehr langsam -60% Speicher, CPU jeweils einige Sekunden 100%
//Production Build ohne Cache: 100 Positionen OK
const numberPositions = 100;
const document: IDocument = initDocument(numberPositions);

export function DocumentRef() {
  const [toggleRender, doToggleRender] = useState<boolean>(true);
  const [caching, setCaching] = useState<boolean>(true);

  //jeder Aufruf arbeitet auf derselben Referenz
  //analog HttpSession
  const docRef = useRef<IDocument>(document);

  //hier wird nur noch der Beleg berechnet und Rendern getriggered
  function updateDocument() {
    calcHeader(docRef.current);
    doToggleRender((toggleRender) => !toggleRender);
  }

  //in place Delete/Insert
  function deletePos(pos: IPosition) {
    document.positions.splice(
      document.positions.findIndex((p) => p.id === pos.id),
      1
    );
    updateDocument();
  }

  function insertPos(pos: IPosition) {
    let nextId =
      document.positions.reduce((prev, current) => {
        return Math.max(prev ?? 0, current.id ?? 0);
      }, 0) + 1;
    document.positions.splice(
      document.positions.findIndex((p) => p.id === pos.id),
      0,
      { id: nextId, net: 0, vatrate: 20, vat: 0, gross: 0 }
    );
    updateDocument();
  }

  
  return (
    <>
      Cache
      <Checkbox
        checked={caching}
        onClick={() => setCaching((c) => !c)}
      ></Checkbox>
      <Header {...docRef.current} />
      <Table>
        <TableBody>
          {docRef.current.positions.map((pos) => (
            <Position
              key={pos.id}
              //jetzt Referenz auf die Position
              //index wird nicht mehr benoetigt=
              pos={pos}
              caching={caching}
              updateDocument={updateDocument}
              deletePos={deletePos}
              insertPos={insertPos}
            />
          ))}
        </TableBody>
      </Table>
    </>
  );
}

const UnCachedPosition: React.FC<IPosHolder> = (posholder) => {
  const pos = posholder.pos;

  return (
    <TableRow>
      <TableCell>
        <Button
          variant="contained"
          color="secondary"
          onClick={(e) => posholder.insertPos(pos)}
        >
          Insert
        </Button>
      </TableCell>
      <PositionCell {...posholder} att={"id"} readonly={true} />
      <PositionCell {...posholder} att="net" readonly={false} />
      <PositionCell {...posholder} att="vatrate" readonly={false} />
      <PositionCell {...posholder} att="vat" readonly={true} />
      <PositionCell {...posholder} att="gross" readonly={true} />
      <PositionCell {...posholder} att="postext" readonly={false} />
      <TableCell>
        {" "}
        <Button
          variant="contained"
          color="secondary"
          //          startIcon={<DeleteIcon />}
          onClick={(e) => posholder.deletePos(pos)}
        >
          Delete
        </Button>
      </TableCell>
    </TableRow>
  );
};

const Position: React.FC<IPosHolder> = (posholder) => {
  const pos = posholder.pos;
  if (posholder.caching) {
    return useMemo(() => UnCachedPosition(posholder), [
      pos.id,
      pos.net,
      pos.vatrate,
      pos.postext,
    ]);
  }
  return UnCachedPosition(posholder);
};

function Header(doc: IDocument) {
  return (
    <div>
      Net: {doc.net}
      <br />
      Vat: {doc.vat}
      <br />
      Gross: {doc.gross}
      <br />
      Positions: {doc.positions.length}
    </div>
  );
}

function PositionCell(posholder: IPosHolderAtt) {
  const pos = posholder.pos;

  //Position wird jetzt lokal aktualisiert und berechnet
  const update = (value: any) => {
    if (typeof pos[posholder.att] === "number") {
      value = round2(Number(value));
    }
    pos[posholder.att] = value;
    calcPosition(pos);
    posholder.updateDocument();
  };

  return (
    <TableCell>
      {!posholder.readonly ? (
        <TextField
          disabled={false}
          label={posholder.att}
          name={posholder.att}
          helperText={typeof pos[posholder.att]}
          defaultValue={pos[posholder.att]}
          onBlur={(e) => {
            update(e.target.value);
          }}
        ></TextField>
      ) : (
        <TextField
          disabled={true}
          label={posholder.att}
          name={posholder.att}
          helperText={typeof pos[posholder.att]}
          value={pos[posholder.att]}
        ></TextField>
      )}
    </TableCell>
  );
}

function initDocument(n: number) {
  const document: IDocument = {
    id: 1,
    net: 0,
    positions: [],
  };

  for (let i = 1; i < n + 1; i++) {
    const net = round2(10 * Math.log10(i));
    const vatrate = 20;
    const position: IPosition = {
      id: i,
      net: net,
      vatrate: vatrate,
      servicedate: new Date(),
      postext: "",
    };
    //Positionen werden jetzt sofort berechnet
    calcPosition(position);
    document.positions.push({ ...position, id: i });
  }

  calcHeader(document);
  return document;
}

function calcHeader(doc: IDocument) {
  doc.net = sumAtt(doc.positions, "net");
  doc.vat = sumAtt(doc.positions, "vat");
  doc.gross = sumAtt(doc.positions, "gross");
}

function calcPosition(pos: IPosition) {
  if (pos.net && pos.vatrate) {
    pos.vat = round2((pos.net * pos.vatrate) / 100);
    pos.gross = round2(pos.net + pos.vat);
  } else {
    pos.vat = 0;
    pos.gross = 0;
  }
}

function sumAtt(positions: IPosition[], att: keyof IPosition) {
  return round2(
    positions.reduce(function (sum, pos) {
      return sum + (pos[att] as number);
    }, 0)
  );
}

function round2(x: number) {
  return Math.round(100 * x) / 100;
}

interface INetGross {
  id?: number;
  net?: number;
  vat?: number;
  gross?: number;
}

interface IDocument extends INetGross {
  positions: IPosition[];
}

interface IPosition extends INetGross {
  vatrate?: number;
  postext?: string;
  servicedate?: Date;
}

interface IPosHolder {
  caching: boolean;
  pos: IPosition;
  updateDocument: any;
  deletePos?: any;
  insertPos?: any;
}

interface IPosHolderAtt extends IPosHolder {
  att: keyof IPosition;
  readonly: boolean;
}
