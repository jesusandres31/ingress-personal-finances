import { NextFunction, Request, Response } from 'express';
import { ILabel } from '../interfaces';
import { labelsSvcs } from '../services';

class LabelsCtrl {
  /**
   * create label
   */
  public createLabel = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const data: ILabel = req.body;
      const createdLabel = await labelsSvcs.createLabel(data);
      if (createdLabel) {
        return res.status(200).json({
          message: `Income ${createdLabel.uuid} successfully created.`,
          data: createdLabel,
        });
      }
      return next({ status: 400, message: 'Something went wrong.' });
    } catch (e) {
      return next(e);
    }
  };

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

  /**
   * update label
   */
  public updateLabelByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const data: ILabel = req.body;
      const updatedLabel = await labelsSvcs.updateLabelByUuid(data);
      if (updatedLabel) {
        return res.status(200).json({
          message: `Label ${updatedLabel.uuid} successfully updated.`,
          data: updatedLabel,
        });
      }
      return next({ status: 400, message: 'No label with such Uuid.' });
    } catch (e) {
      return next(e);
    }
  };

  /**
   * delete label
   */
  public deleteLabelByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { uuid } = req.params;
      const deletedLabel = await labelsSvcs.deleteLabelByUuid(uuid);
      if (deletedLabel) {
        return res.status(200).json({
          message: `Label ${deletedLabel.uuid} successfully deleted.`,
          data: deletedLabel,
        });
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
