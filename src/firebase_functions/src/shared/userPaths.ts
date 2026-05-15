export const userPaths = {
  userDoc: (uid: string) => `users/${uid}`,
  pushTokensCol: (uid: string) => `users/${uid}/pushTokens`,
  pushTokenDoc: (uid: string, tokenId: string) => `users/${uid}/pushTokens/${tokenId}`
};
