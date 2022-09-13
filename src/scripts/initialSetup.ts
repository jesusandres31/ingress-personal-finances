import { db } from '../database';

/**
 * create label types.
 */
const createLabelTypes = async () => {
  /* BEGIN;

    INSERT INTO "setup"."label_types" (id, name) VALUES (1, 'incomes');
    INSERT INTO "setup"."label_types" (id, name) VALUES (2, 'outcomes');

    COMMIT; */
  /* const roles = await authSvcs.getRoles();
  if (roles.length !== 0) {
    return console.log("Roles are already created.");
  } else {
    try {
      const createdRoles = await db.func("insert_roles_data", []);
      if (createdRoles) {
        return console.log("Roles successfully created.");
      }
      return console.log("There was a problem creating Roles.");
    } catch (e) {
      return console.log(e);
    }
  } */
};
