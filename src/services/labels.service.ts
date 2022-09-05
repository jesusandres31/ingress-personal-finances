import { db, qrm } from '../database';
import { ILabel } from '../interfaces';

class LabelsSvcs {
  /**
   * create label
   */
  public createLabel = async (data: ILabel): Promise<ILabel> => {
    const label: ILabel[] = await db.func(
      'setup.labels_create',
      [data.name],
      qrm.any,
    );
    return label[0];
  };

  /**
   * get all labels
   */
  public getLabels = (
    offset: string,
    limit: string,
    filter: string,
    sortColumn: string,
    sortDirection: string,
  ): Promise<ILabel[]> => {
    return db.func('setup.labels_get_all', [
      offset,
      limit,
      filter,
      sortColumn,
      sortDirection,
    ]);
  };

  /**
   * get one label
   */
  public getLabelByUuid = (uuid: string): Promise<ILabel> => {
    return db.func('setup.labels_get_one_by_uuid', [uuid], qrm.one);
  };

  /**
   * update label
   */
  public updateLabelByUuid = async (data: ILabel): Promise<ILabel> => {
    const taxpayer: ILabel[] = await db.func(
      'setup.labels_update',
      [data.name],
      qrm.any,
    );
    return taxpayer[0];
  };

  /**
   * delete label
   */
  public deleteLabelByUuid = (uuid: string): Promise<ILabel> => {
    return db.func('setup.labels_delete', [uuid], qrm.one);
  };
}

export const labelsSvcs = new LabelsSvcs();
