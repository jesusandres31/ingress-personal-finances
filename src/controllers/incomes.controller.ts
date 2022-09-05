import { NextFunction, Request, Response } from 'express';
import { IIncome } from '../interfaces';
import { incomesSvcs } from '../services';

class IncomesCtrl {
  /**
   * create income
   */
  public createIncome = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const data: IIncome = req.body;
      const createdIncome = await incomesSvcs.createIncome(data);
      if (createdIncome) {
        return res.status(200).json({
          message: `Income ${createdIncome.uuid} successfully created.`,
          data: createdIncome,
        });
      }
      return next({ status: 400, message: 'Something went wrong.' });
    } catch (e) {
      return next(e);
    }
  };

  /**
   * get all incomes
   */
  public getIncomes = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { offset, limit, filter, sortColumn, sortDirection } = req.query;
      const incomes = await incomesSvcs.getIncomes(
        offset as string,
        limit as string,
        filter as string,
        sortColumn as string,
        sortDirection as string,
      );
      return res.status(200).json(incomes);
    } catch (e) {
      return next(e);
    }
  };

  /**
   * get one income
   */
  public getIncomeByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { uuid } = req.params;
      const income = await incomesSvcs.getIncomeByUuid(uuid);
      if (income) {
        return res.status(200).json(income);
      }
      return next({
        status: 400,
        message: 'No income with such Uuid.',
      });
    } catch (e) {
      return next(e);
    }
  };

  /**
   * update income
   */
  public updateIncomeByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const data: IIncome = req.body;
      const updatedIncome = await incomesSvcs.updateIncomeByUuid(data);
      if (updatedIncome) {
        return res.status(200).json({
          message: `Income ${updatedIncome.uuid} successfully updated.`,
          data: updatedIncome,
        });
      }
      return next({ status: 400, message: 'No income with such Uuid.' });
    } catch (e) {
      return next(e);
    }
  };

  /**
   * delete income
   */
  public deleteIncomeByUuid = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> => {
    try {
      const { uuid } = req.params;
      const deletedIncome = await incomesSvcs.deleteIncomeByUuid(uuid);
      if (deletedIncome) {
        return res.status(200).json({
          message: `Income ${deletedIncome.uuid} successfully deleted.`,
          data: deletedIncome,
        });
      }
      return next({
        status: 400,
        message: 'No income with such Uuid.',
      });
    } catch (e) {
      return next(e);
    }
  };
}

export const incomesCtrl = new IncomesCtrl();
