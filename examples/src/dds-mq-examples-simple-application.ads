with DDS.Mq.Examples.Simple.Messaging.Client;
with DDS.Mq.Examples.Simple.Messaging.Server;
with DDS.Mq.Examples.Simple.Listners;
package DDS.Mq.Examples.Simple.Application is
   Listner      : aliased Listners.Ref;
   Writer       : Messaging.Client.Ref_Access;
   Reader       : Messaging.Server.Ref_Access;

end DDS.Mq.Examples.Simple.Application;
