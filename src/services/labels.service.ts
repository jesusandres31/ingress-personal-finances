import { db } from '../database';
import { ILabel } from '../interfaces';

class LabelsSvcs {
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
    return db.any(
      `
        SELECT l.uuid, l.name
        FROM setup.labels AS l
        WHERE (LOWER(l.name) LIKE LOWER('%' || $1 || '%'))
        ORDER BY l.$4~ $5#
        LIMIT $2 OFFSET ($3 - 1) * $2;
      `,
      [filter, limit, offset, sortColumn, sortDirection],
    );
  };

  /**
   * get one label
   */
  public getLabelByUuid = (uuid: string): Promise<ILabel> => {
    return db.one(
      `
        SELECT l.uuid, l.name
        FROM setup.labels AS l 
        WHERE uuid = $1;
      `,
      [uuid],
    );
  };
}

export const labelsSvcs = new LabelsSvcs();
