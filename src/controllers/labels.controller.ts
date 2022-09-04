import { NextFunction, Request, Response } from 'express';
import { labelsSvcs } from '../services';

class LabelsCtrl {
  /**
   * get all labels
   */
  public getLabels = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { offset, limit, filter, sortColumn, sortDirection } = req.query;
      const labels = await labelsSvcs.getLabels(
        offset as string,
        limit as string,
        filter as string,
        sortColumn as string,
        sortDirection as string,
      );
      return res.status(200).json(labels);
    } catch (e) {
      return next(e);
    }
  };

  /**
   * get one label
   */
  public getLabelByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { uuid } = req.params;
      const label = await labelsSvcs.getLabelByUuid(uuid);
      if (label) {
        return res.status(200).json(label);
      }
      return next({
        status: 400,
        message: 'No label with such Uuid.',
      });
    } catch (e) {
      return next(e);
    }
  };
}

export const labelsCtrl = new LabelsCtrl();
