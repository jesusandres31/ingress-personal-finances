import { db, qrm } from '../database';
import { IIncome } from '../interfaces';

class IncomesSvcs {
  /**
   * create income
   */
  public createIncome = async (data: IIncome): Promise<IIncome> => {
    const income: IIncome[] = await db.func(
      'setup.incomes_create',
      [data.date, data.labelId, data.description, data.total],
      qrm.any,
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
    return db.func('setup.incomes_get_all', [
      offset,
      limit,
      filter,
      sortColumn,
      sortDirection,
    ]);
  };

  /**
   * get one income
   */
  public getIncomeByUuid = (uuid: string): Promise<IIncome> => {
    return db.func('setup.incomes_get_one_by_uuid', [uuid], qrm.one);
  };

  /**
   * update income
   */
  public updateIncomeByUuid = async (data: IIncome): Promise<IIncome> => {
    const taxpayer: IIncome[] = await db.func(
      'setup.incomes_update',
      [data.date, data.labelId, data.description, data.total],
      qrm.any,
    );
    return taxpayer[0];
  };

  /**
   * delete income
   */
  public deleteIncomeByUuid = (uuid: string): Promise<IIncome> => {
    return db.func('setup.incomes_delete', [uuid], qrm.one);
  };
}

export const incomesSvcs = new IncomesSvcs();
