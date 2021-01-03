import React from "react";
import {
  Button,
  Checkbox,
  Table,
  TableBody,
  TableCell,
  TableFooter,
  TableHead,
  TablePagination,
  TableRow,
  TextField,
} from "@material-ui/core";

import { useState, useMemo, useRef } from "react";
import TablePaginationActions from "@material-ui/core/TablePagination/TablePaginationActions";
import { Store, IPosition, IDocument } from "./Store";

export function DocumentStore() {
  const [, forceRender] = useState<boolean>(true);
  const storeRef = useRef<Store>(new Store(forceRender));

  const [caching, setCaching] = useState<boolean>(true);

  const [page, setPage] = React.useState(0);
  const [rowsPerPage, setRowsPerPage] = React.useState(5);
  const rows = storeRef.current.document.positions;

  const handleChangePage = (event: any, newPage: any) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event: any) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  return (
    <>
      Cache
      <Checkbox checked={caching} onClick={() => setCaching((c) => !c)} />
      <Header {...storeRef.current.document} />
      <Table>
        <TableHead>
          <TableRow>
            <TablePagination
              rowsPerPageOptions={[5, 100, 1000, 5000]}
              colSpan={3}
              count={rows.length}
              rowsPerPage={rowsPerPage}
              page={page}
              SelectProps={{
                inputProps: { "aria-label": "rows per page" },
                native: true,
              }}
              onChangePage={handleChangePage}
              onChangeRowsPerPage={handleChangeRowsPerPage}
              ActionsComponent={TablePaginationActions}
            />
          </TableRow>
        </TableHead>
        <TableBody>
          {(rowsPerPage > 0
            ? rows.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
            : rows
          ).map((pos) => (
            <Position
              key={pos.id}
              pos={pos}
              caching={caching}
              store={storeRef.current}
            />
          ))}
        </TableBody>
        <TableFooter>
          <TableRow>
            <TablePagination
              rowsPerPageOptions={[5, 100, 1000, 5000]}
              colSpan={3}
              count={rows.length}
              rowsPerPage={rowsPerPage}
              page={page}
              SelectProps={{
                inputProps: { "aria-label": "rows per page" },
                native: true,
              }}
              onChangePage={handleChangePage}
              onChangeRowsPerPage={handleChangeRowsPerPage}
              ActionsComponent={TablePaginationActions}
            />
          </TableRow>
        </TableFooter>
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
          onClick={(e) => posholder.store.insertPos(pos)}
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
          onClick={(e) => posholder.store.deletePos(pos)}
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
  const store = posholder.store;
  const update = (value: any) => {
    if (typeof pos[posholder.att] === "number") {
      value = round2(Number(value));
    }
    pos[posholder.att] = value;
    store.calcPosition(pos);
    store.updateDocument();
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

function round2(x: number) {
  return Math.round(100 * x) / 100;
}

interface IPosHolder {
  caching: boolean;
  pos: IPosition;
  store: Store;
}

interface IPosHolderAtt extends IPosHolder {
  att: keyof IPosition;
  readonly: boolean;
}
