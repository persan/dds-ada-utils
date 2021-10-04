with  DDS.Mq.Tests.Simple.Messaging.Server;
package DDS.Mq.Tests.Simple.Listners is
   type Ref is new Messaging.Server.Listners.Ref with  null record;
   overriding procedure On_Data (Self   : not null access Ref;
                                 Reader : not null  Messaging.Server.Ref_Access;
                                 Data   : Message_Type);

end DDS.Mq.Tests.Simple.Listners;
