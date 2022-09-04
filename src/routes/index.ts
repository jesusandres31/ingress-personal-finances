import { Router } from 'express';
import labelsRoutes from './labels.routes';
import incomesRoutes from './incomes.routes';
import outcomesRoutes from './outcomes.routes';

const router = Router();

router.use('/api', labelsRoutes, outcomesRoutes, incomesRoutes);

export default router;
