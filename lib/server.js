Parse.Cloud.define("functionMigrationTest", async (request) => {
    console.log(request);
    const query = new Parse.Query("migrationTest");
    return await query.find({useMasterKey:true}).then(function(res){
      console.log(res);
      return res;
    }).catch(function(e){
      console.log(e);
      throw new Error(e);
    });
  });