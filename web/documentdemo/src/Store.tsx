import React from "react";


interface INetGross {
  id?: number;
  net?: number;
  vat?: number;
  gross?: number;
}

export interface IDocument extends INetGross {
  positions: IPosition[];
}

export interface IPosition extends INetGross {
  vatrate?: number;
  postext?: string;
  servicedate?: Date;
}


const numberPositions = 5000;

export class Store {

  public document: IDocument;


  private forceRender: any;

  constructor(forceRender: any) {
    this.forceRender = forceRender;
    this.document = {
      id: 1,
      net: 0,
      positions: [],
    };

    for (let i = 1; i < numberPositions + 1; i++) {
      const net = round2(10 * Math.log10(i));
      const vatrate = 20;
      const position: IPosition = {
        id: i,
        net: net,
        vatrate: vatrate,
        servicedate: new Date(),
        postext: "",
      };
      this.calcPosition(position);
      this.document.positions.push({ ...position, id: i });
    }

    this.calcHeader(this.document);
  }


  updateDocument() {
    this.calcHeader(this.document);
    this.forceRender((forceRender: boolean) => !forceRender);
  }

  deletePos(pos: IPosition) {
    this.document.positions.splice(
      this.document.positions.findIndex((p) => p.id === pos.id),
      1
    );
    this.updateDocument();
  }

  insertPos(pos: IPosition) {
    let nextId =
      this.document.positions.reduce((prev, current) => {
        return Math.max(prev ?? 0, current.id ?? 0);
      }, 0) + 1;
    this.document.positions.splice(
      this.document.positions.findIndex((p) => p.id === pos.id),
      0,
      { id: nextId, net: 0, vatrate: 20, vat: 0, gross: 0 }
    );
    this.updateDocument();
  }

  calcPosition(pos: IPosition) {
    if (pos.net && pos.vatrate) {
      pos.vat = round2((pos.net * pos.vatrate) / 100);
      pos.gross = round2(pos.net + pos.vat);
    } else {
      pos.vat = 0;
      pos.gross = 0;
    }
  }
  calcHeader(doc: IDocument) {
    doc.net = sumAtt(doc.positions, "net");
    doc.vat = sumAtt(doc.positions, "vat");
    doc.gross = sumAtt(doc.positions, "gross");
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

