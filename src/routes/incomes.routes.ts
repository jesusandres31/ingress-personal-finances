import { Router } from 'express';
import { incomesCtrl } from '../controllers';

const router = Router();

router.post('/incomes', incomesCtrl.createIncome);

router.get('/incomes', incomesCtrl.getIncomes);

router.get('/incomes/:uuid', incomesCtrl.getIncomeByUuid);

router.put('/incomes/:uuid', incomesCtrl.updateIncomeByUuid);

router.delete('/incomes/:uuid', incomesCtrl.deleteIncomeByUuid);

export default router;
