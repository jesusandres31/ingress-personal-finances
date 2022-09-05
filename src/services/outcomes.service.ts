import { db, qrm } from '../database';
import { IOutcome } from '../interfaces';

class OutcomesSvcs {
  /**
   * create outcome
   */
  public createOutcome = async (data: IOutcome): Promise<IOutcome> => {
    const outcome: IOutcome[] = await db.func(
      'setup.outcomes_create',
      [data.date, data.labelId, data.description, data.total],
      qrm.any,
    );
    return outcome[0];
  };

  /**
   * get all outcomes
   */
  public getOutcomes = (
    offset: string,
    limit: string,
    filter: string,
    sortColumn: string,
    sortDirection: string,
  ): Promise<IOutcome[]> => {
    return db.func('setup.outcomes_get_all', [
      offset,
      limit,
      filter,
      sortColumn,
      sortDirection,
    ]);
  };

  /**
   * get one outcome
   */
  public getOutcomeByUuid = (uuid: string): Promise<IOutcome> => {
    return db.func('setup.outcomes_get_one_by_uuid', [uuid], qrm.one);
  };

  /**
   * update outcome
   */
  public updateOutcomeByUuid = async (data: IOutcome): Promise<IOutcome> => {
    const taxpayer: IOutcome[] = await db.func(
      'setup.outcomes_update',
      [data.date, data.labelId, data.description, data.total],
      qrm.any,
    );
    return taxpayer[0];
  };

  /**
   * delete outcome
   */
  public deleteOutcomeByUuid = (uuid: string): Promise<IOutcome> => {
    return db.func('setup.outcomes_delete', [uuid], qrm.one);
  };
}

export const outcomesSvcs = new OutcomesSvcs();
