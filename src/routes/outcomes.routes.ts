import { Router } from 'express';
import { outcomesCtrl } from '../controllers';

const router = Router();

router.post('/outcomes', outcomesCtrl.createOutcome);

router.get('/outcomes', outcomesCtrl.getOutcomes);

router.get('/outcomes/:uuid', outcomesCtrl.getOutcomeByUuid);

router.put('/outcomes/:uuid', outcomesCtrl.updateOutcomeByUuid);

router.delete('/outcomes/:uuid', outcomesCtrl.deleteOutcomeByUuid);

export default router;
