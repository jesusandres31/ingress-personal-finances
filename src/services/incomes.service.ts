import { db } from '../database';
import { IIncome } from '../interfaces';

class IncomesSvcs {
  /**
   * create a income
   */
  public createIncome = async (data: IIncome): Promise<IIncome> => {
    const income: IIncome[] = await db.one(
      `
        INSERT INTO setup.incomes(uuid, date, label, description, total)
        SELECT uuid_generate_v4(), $1, $2, $3, $4
      `,
      [data.date, data.label, data.description, data.total],
    );
    return income[0];
  };

  /**
   * get all incomes
   */
  public getIncomes = (
    offset: string,
    limit: string,
    filter: string,
    sortColumn: string,
    sortDirection: string,
  ): Promise<IIncome[]> => {
    return db.any(
      `
        SELECT i.uuid, i.name
        FROM setup.incomes AS i
        WHERE (LOWER(i.name) LIKE LOWER('%' || $1 || '%'))
        ORDER BY i.$4~ $5#
        LIMIT $2 OFFSET ($3 - 1) * $2;
      `,
      [filter, limit, offset, sortColumn, sortDirection],
    );
  };

  /**
   * get one income
   */
  public getIncomByUuid = (uuid: string): Promise<IIncome> => {
    return db.one(
      `
        SELECT i.uuid, i.name
        FROM setup.incomes AS i 
        WHERE uuid = $1;
      `,
      [uuid],
    );
  };
}

export const incomesSvcs = new IncomesSvcs();
