import { Router } from 'express';
import { labelsCtrl } from '../controllers';

const router = Router();

/**
 * get all labels
 */
router.get('/labels', labelsCtrl.getLabels);

/**
 * get one label
 */
router.get('/labels/:uuid', labelsCtrl.getLabelByUuid);

export default router;
