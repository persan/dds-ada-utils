with DDS.Mq.Tests.Simple.Messaging.Client;
with DDS.Mq.Tests.Simple.Messaging.Server;
with DDS.Mq.Tests.Simple.Listners;
package DDS.Mq.Tests.Simple.Application is
   Listner      : aliased Listners.Ref;
   Writer       : Messaging.Client.Ref_Access;
   Reader       : Messaging.Server.Ref_Access;

end DDS.Mq.Tests.Simple.Application;
