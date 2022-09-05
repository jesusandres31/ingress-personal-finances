import { NextFunction, Request, Response } from 'express';
import { IOutcome } from '../interfaces';
import { outcomesSvcs } from '../services';

class OutcomesCtrl {
  /**
   * create outcome
   */
  public createOutcome = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const data: IOutcome = req.body;
      const createdOutcome = await outcomesSvcs.createOutcome(data);
      if (createdOutcome) {
        return res.status(200).json({
          message: `Outcome ${createdOutcome.uuid} successfully created.`,
          data: createdOutcome,
        });
      }
      return next({ status: 400, message: 'Something went wrong.' });
    } catch (e) {
      return next(e);
    }
  };

  /**
   * get all outcomes
   */
  public getOutcomes = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { offset, limit, filter, sortColumn, sortDirection } = req.query;
      const outcomes = await outcomesSvcs.getOutcomes(
        offset as string,
        limit as string,
        filter as string,
        sortColumn as string,
        sortDirection as string,
      );
      return res.status(200).json(outcomes);
    } catch (e) {
      return next(e);
    }
  };

  /**
   * get one outcome
   */
  public getOutcomeByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { uuid } = req.params;
      const outcome = await outcomesSvcs.getOutcomeByUuid(uuid);
      if (outcome) {
        return res.status(200).json(outcome);
      }
      return next({
        status: 400,
        message: 'No outcome with such Uuid.',
      });
    } catch (e) {
      return next(e);
    }
  };

  /**
   * update outcome
   */
  public updateOutcomeByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const data: IOutcome = req.body;
      const updatedOutcome = await outcomesSvcs.updateOutcomeByUuid(data);
      if (updatedOutcome) {
        return res.status(200).json({
          message: `Outcome ${updatedOutcome.uuid} successfully updated.`,
          data: updatedOutcome,
        });
      }
      return next({ status: 400, message: 'No Outcome with such Uuid.' });
    } catch (e) {
      return next(e);
    }
  };

  /**
   * delete outcome
   */
  public deleteOutcomeByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { uuid } = req.params;
      const deletedOutcome = await outcomesSvcs.deleteOutcomeByUuid(uuid);
      if (deletedOutcome) {
        return res.status(200).json({
          message: `Outcome ${deletedOutcome.uuid} successfully deleted.`,
          data: deletedOutcome,
        });
      }
      return next({
        status: 400,
        message: 'No outcome with such Uuid.',
      });
    } catch (e) {
      return next(e);
    }
  };
}

export const outcomesCtrl = new OutcomesCtrl();
