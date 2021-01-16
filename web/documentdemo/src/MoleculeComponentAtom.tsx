import {
  Button,
  Table,
  TableBody,
  TableCell,
  TableRow,
  TextField,
} from "@material-ui/core";

import { Provider, atom, Atom, useAtom } from "jotai";
import { atomFamily, useAtomValue } from "jotai/utils";
import { Getter, WritableAtom } from "jotai/core/types";

const numberPositions = 50;

interface INetPosition {
  id: number;
  net: number;
  vatrate: number;
  postext?: string;
}

interface IPosition extends INetPosition {
  vat: number;
  gross: number;
}

//das ist der notwendige Input für die PositionComponent
//die Position Daten selbst werden aus der entspr. Atomfamilie geholt
interface IPositionComponentInput {
  id: number;
  //optional wegen remove
  insertPos?: (atId: number) => void;
  deletePos?: (atId: number) => void;
  setPosition?: any;
}

interface IPositionAtt extends IPosition {
  att: keyof IPosition;
  //für schreibbare Spalten
  updateatt?: keyof INetPosition;
  setPosition?: any;
}

interface IDocumentHeader {
  id: number;
  net: number;
  vat: number;
  gross: number;
  numberPositions: number;
}

const atomfamilyNetPositions = atomFamily((param: INetPosition) => param);

// atomfamilyPositions verwaltet abgeleitete aber trotzdem schreibbare Atome
// (explizite write Funktion) (so ein Art Updatable View)
// kriegt Netposition POJO, liefert Position Atom
// der Lookup benutzt nur Id der NetPosition
// nicht schön: beim Lookup muss auch Nettowert und Vatrate übergeben werden
const atomfamilyPositions = atomFamily(
  (param: INetPosition) => (get) => {
    const netpos = get(atomfamilyNetPositions(param));
    const vat = round2((netpos.net * netpos.vatrate) / 100);
    return { ...netpos, vat: vat, gross: netpos.net + vat };
  },
  (param: INetPosition) => (get, set, _arg) => {
    const netposAtom = atomfamilyNetPositions(param);
    set(netposAtom, _arg as INetPosition);
  },
  (a: INetPosition, b: INetPosition) => a.id === b.id
);

const positionIdsAtom = initPositions(numberPositions);

function initPositions(n: number): WritableAtom<number[], number[]> {
  const ids = [];
  for (let i = 1; i < n + 1; i++) {
    const id = i;
    ids.push(id);
    const netPos = {
      id: id,
      net: round2(10 * Math.log10(i)),
      vatrate: 20,
    };
    //Atom für NetPosition und Position
    atomfamilyNetPositions(netPos);
    atomfamilyPositions(netPos);
  }
  return atom<number[]>(ids);
}

const atomHeader = atom<IDocumentHeader>(defineComputeHeader());
//hier wird reaktive Berechnung des Headers spezifiziert/berechnet
function defineComputeHeader() {
  return (get: Getter) => {
    const ids = get(positionIdsAtom);
    const positions = ids.map((id) =>
      get(
        atomfamilyPositions(
          get(atomfamilyNetPositions({ id, net: 0, vatrate: 0 }))
        )
      )
    );
    return {
      id: 1,
      net: sum(positions, "net"),
      vat: sum(positions, "vat"),
      gross: sum(positions, "gross"),
      numberPositions: positions.length,
    };
  };
}

function Header({ atomHeader }: { atomHeader: Atom<IDocumentHeader> }) {
  const doc = useAtomValue(atomHeader);
  return (
    <div>
      Net: {doc.net}
      <br />
      Vat: {doc.vat}
      <br />
      Gross: {doc.gross}
      <br />
      Positions: {doc.numberPositions}
    </div>
  );
}

export function MoleculeComponentAtom() {
  return (
    <Provider>
      <Header atomHeader={atomHeader} />
      <Positions positionIdsAtom={positionIdsAtom} />
    </Provider>
  );
}

// Rerendering:
// funktioniert (ohne memo) beim Update einer Position wie gewünscht
// Die Positionskomponente ist jetzt auch reaktiv und wird nur neu berechnet, wenn sich die Position geändert hat
function Positions({
  positionIdsAtom,
}: {
  positionIdsAtom: WritableAtom<number[], number[]>;
}) {
  const [ids, setIds] = useAtom(positionIdsAtom);

  const insertPos = (atId: number) => {
    let nextId =
      ids.reduce((prev, current) => {
        return Math.max(prev, current);
      }, 0) + 1;
    const netPosition = { id: nextId, net: 0, vatrate: 20 };
    atomfamilyNetPositions(netPosition);
    atomfamilyPositions(netPosition);

    ids.splice(
      ids.findIndex((id) => id === atId),
      0,
      nextId
    );
    //das ist wie bei useState, per Default Referenz Equality für Change Detection
    setIds([...ids]);
  };

  //TODO: remove/insert ist  buggy (mehrere Male insert/delete > Positionsliste ist out of sync)

  const deletePos = (atId: number) => {
    atomfamilyNetPositions.remove({ id: atId, net: 0, vatrate: 0 });
    atomfamilyPositions.remove({ id: atId, net: 0, vatrate: 0 });
    atomfamilyComponents.remove({id: atId})
    ids.splice(
      ids.findIndex((id) => id === atId),
      1
    );
    setIds([...ids]);
  };

  return (
    <Table>
      <TableBody>
        {ids.map((id) => (
          <Position
            key={id}
            deletePos={deletePos}
            id={id}
            insertPos={insertPos}
          />
        ))}
      </TableBody>
    </Table>
  );
}

function Position({
  id,
  insertPos,
  deletePos,
}: {
  id: number;
  insertPos: (atId: number) => void;
  deletePos: (atId: number) => void;
}) {
  //hier wird der Setter für die Position geholt
  //das scheint in atomfamilyComponents nicht möglich zu sein
  const [, setPosition] = useAtom(
    atomfamilyPositions({ id: id, net: 0, vatrate: 0 })
  );
  const positionComponent: IPositionComponentInput = {
    id: id,
    setPosition,
    insertPos,
    deletePos,
  };
  return useAtomValue(atomfamilyComponents(positionComponent));
}

//reaktive Berechnung der React Komponente PositionComponent
const atomfamilyComponents = atomFamily(
  (param: IPositionComponentInput) => (get) => {
    const position = get(
      atomfamilyPositions({ id: param.id, net: 0, vatrate: 0 })
    );
    return PositionComponent({
      ...position,
      setPosition: param.setPosition,
      insertPos: param.insertPos,
      deletePos: param.deletePos,
    });
  },
  null,
  (a: IPositionComponentInput, b: IPositionComponentInput) => a.id === b.id
);

function PositionComponent(pos: IPositionComponentInput & IPosition) {
  return (
    <TableRow>
      <TableCell>
        <Button
          variant="contained"
          color="secondary"
          onClick={() => {
            pos.insertPos!(pos.id);
          }}
        >
          Insert
        </Button>
      </TableCell>
      <PositionCell {...pos} att="id" />
      <PositionCell
        {...pos}
        setPosition={pos.setPosition}
        att="net"
        updateatt="net"
      />
      <PositionCell
        {...pos}
        setPosition={pos.setPosition}
        att="vatrate"
        updateatt="vatrate"
      />
      <PositionCell {...pos} att="vat" />
      <PositionCell {...pos} att="gross" />
      <PositionCell
        {...pos}
        setPosition={pos.setPosition}
        att="postext"
        updateatt="postext"
      />
      <TableCell>
        {" "}
        <Button
          variant="contained"
          color="secondary"
          onClick={() => pos.deletePos!(pos.id)}
        >
          Delete
        </Button>
      </TableCell>
    </TableRow>
  );
}

function PositionCell(pos: IPositionAtt) {
  return (
    <TableCell>
      {pos.updateatt ? (
        <TextField
          disabled={false}
          label={pos.att}
          name={pos.att}
          helperText={typeof pos[pos.att]}
          defaultValue={pos[pos.att]}
          onBlur={(e) => {
            let value = e.target.value as any;
            const newPos = {
              id: pos.id,
              net: pos.net,
              vatrate: pos.vatrate,
              postext: pos.postext,
            };
            if (typeof pos[pos.att] === "number") {
              value = round2(Number(value));
            }
            //strict null checks - TS akzeptiert den Guard oben nicht
            //https://github.com/microsoft/TypeScript/issues/31663 (cast)
            (newPos[pos.updateatt!] as any) = value;
            pos.setPosition(newPos);
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

function sum(positions: IPosition[], att: keyof IPosition) {
  return round2(
    positions.reduce(function (sum, pos) {
      return sum + (pos[att] as number);
    }, 0)
  );
}

function round2(x: number) {
  return Math.round(100 * x) / 100;
}
