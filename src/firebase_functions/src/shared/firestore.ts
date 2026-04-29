import admin from "firebase-admin";

let _initialized = false;

export function getDb() {
  if (!_initialized) {
    admin.initializeApp();
    _initialized = true;
  }
  return admin.firestore();
}

export { admin };

