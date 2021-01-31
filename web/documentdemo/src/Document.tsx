import {
  Checkbox,
  Table,
  TableBody,
  TableCell,
  TableRow,
  TextField,
} from "@material-ui/core";
import { useState, useMemo, memo, StrictMode, useCallback } from "react";
var randomColor = require('randomcolor');

const numberPositions = 200;
const document: IDocument = initDocument(numberPositions);

export function Document() {
  const [doc, setDoc] = useState<IDocument>(document);
  const [caching, setCaching] = useState<boolean>(true);

  function updateDocument(att: keyof IPosition, idx: number, value: any) {
    const pos: IPosition = doc.positions[idx];
    if (typeof pos[att] === "number") {
      value = round2(Number(value));
    }
    pos[att] = value;
    calcDoc(doc);
    setDoc({ ...doc });
  }
  //für memo()
  const updateDocumentCallback = useCallback( (att: keyof IPosition, idx: number, value: any) => updateDocument(att, idx, value), []);

  return (
    <StrictMode>
      Toggle Cache
      <Checkbox
        checked={caching}
        onClick={() => setCaching((c) => !c)}
      ></Checkbox>
      <Header {...doc} />
      <Table>
        <TableBody>
          {doc.positions.map((pos, idx) => (
            <Position
              key={pos.id}
              idx={idx}
              {...pos}
              caching={caching}
              updateDocument={updateDocumentCallback}
            />
          ))}
        </TableBody>
      </Table>
    </StrictMode>
  );
}

const UnCachedPosition: React.FC<IPosition> = (pos) => {
  return (
    <TableRow>
      <PositionCell {...pos} att="id" readonly={true} />
      <PositionCell {...pos} att="net" />
      <PositionCell {...pos} att="vatrate" />
      <PositionCell {...pos} att="vat" readonly={true} />
      <PositionCell {...pos} att="gross" readonly={true} />
      <PositionCell {...pos} att="postext" />
      <TableCell style={{color: randomColor()}} >Random Color</TableCell>
    </TableRow>
  );
};

//HOC Variante  - hier ist Cache immer aktiv (keine Vergleichsfunktion)
const HOCPosition = memo(UnCachedPosition);

//HOC Variante mit Compare Funktion
const memoWithCompareFunctionPosition = memo(UnCachedPosition, (p, n) => {
  if (!n.caching) {
    return false;
  }
  //postext nicht wirklich notwendig 
  return n.id === p.id && n.vatrate === p.vatrate && n.net === p.net && n.postext === p.postext;
});

//useMemo Variante
const Position: React.FC<IPosition> = (pos) => {
  if (pos.caching) {
    return useMemo(() => UnCachedPosition(pos), [pos.id, pos.net, pos.vatrate, pos.postext]);
  }
  return UnCachedPosition(pos);
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

function PositionCell(pos: IPositionAtt) {
  return (
    <TableCell>
      {!pos.readonly ? (
        <TextField
          disabled={false}
          label={pos.att}
          name={pos.att}
          helperText={typeof pos[pos.att]}
          defaultValue={pos[pos.att]}
          onBlur={(e) => {
            pos.updateDocument(pos.att, pos.idx, e.target.value);
          }}
        ></TextField>
      ) : (
        <TextField
          disabled={true}
          label={pos.att}
          name={pos.att}
          helperText={typeof pos[pos.att]}
          value={pos[pos.att]}
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
      postext: ""
    };
    document.positions.push({ ...position, id: i });
  }

  calcDoc(document);
  return document;
}

function calcDoc(doc: IDocument) {
  doc.positions.forEach((pos) => calcPosition(pos));

  doc.net = sumAtt(doc.positions, "net");
  doc.vat = sumAtt(doc.positions, "vat");
  doc.gross = sumAtt(doc.positions, "gross");
}

function calcPosition(pos: IPosition) {
  pos.vat = round2((pos.net * pos.vatrate) / 100);
  pos.gross = round2(pos.net + pos.vat);
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

interface NetGross {
  net: number;
  vat?: number;
  gross?: number;
}

interface IDocument extends NetGross {
  id: number;
  positions: IPosition[];
}

interface IPosition extends NetGross {
  id: number;
  vatrate: number;
  postext?: string;
  servicedate: Date;
  updateDocument?: any;
  caching?: boolean;
  idx?: number;
}

interface IPositionAtt extends IPosition {
  att: keyof IPosition;
  readonly?: boolean;
}

