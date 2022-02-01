const sdk = require('node-appwrite');

(async () => {
    const client = new sdk.Client();

    client
        .setEndpoint(process.env.APPWRITE_ENDPOINT)
        .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
        .setKey(process.env.APPWRITE_API_KEY);

    if (process.env.APPWRITE_FUNCTION_TRIGGER !== 'http')
        return console.log(JSON.stringify({ error: 'only http-triggered allowed' }));


    // try {
    //     const data = JSON.parse(process.env.APPWRITE_FUNCTION_DATA);
    // } catch (error) {
    //     return console.log(JSON.stringify({ error }))
    // }

    const db = new sdk.Database(client);

    db.listDocuments(process.env.APPWRITE_COLLECTION_USERS_ID, null, 0);
    console.log(JSON.stringify())


})();


