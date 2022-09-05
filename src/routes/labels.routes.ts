import { Router } from 'express';
import { labelsCtrl } from '../controllers';

const router = Router();

router.post('/labels', labelsCtrl.createLabel);

router.get('/labels', labelsCtrl.getLabels);

router.get('/labels/:uuid', labelsCtrl.getLabelByUuid);

router.put('/labels/:uuid', labelsCtrl.updateLabelByUuid);

router.delete('/labels/:uuid', labelsCtrl.deleteLabelByUuid);

export default router;
