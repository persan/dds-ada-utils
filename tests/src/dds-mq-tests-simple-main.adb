with DDS.DomainParticipant;
with DDS.DomainParticipantFactory;
with DDS.Mq.Tests.Args;
with GNAT.Exception_Traces;
with GNAT.Traceback.Symbolic;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;
with DDS.Mq.Tests.Simple.Messaging.Client;
with DDS.Mq.Tests.Simple.Messaging.Server;
with DDS.Mq.Tests.Simple.Listners;

with DDS.Mq.Tests.Simple.Application;
procedure DDS.Mq.Tests.Simple.Main  is
   use DDS.Mq.Tests.Args;
   use Ada.Strings.Fixed;

   Data         : Message_Type;
begin

   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);

   if Args.Parser.Parse then
      declare
         Topic_Name   : constant DDS.String := +Args.Topic_Name.Get;

      begin
         Application.Writer := Messaging.Client.Create (Topic_Name => Topic_Name);
         Application.Reader := Messaging.Server.Create
           (Listner      => Application.Listner'Access,
            Queue_Lenght => 10,
            Topic_Name   => Topic_Name);
         delay 1.0;
         for I in 1 .. 2 loop
            Put_Line ("sending> " &  "Sample:" & I'Img);
            Move ("Sample:" & I'Img, Data.Name);
            Data.Name_Last := I;
            begin
               Application.Writer.Write (Data);
            exception
               when DDS.TIMEOUT =>
                  Put_Line ("Unable to send> " &  "Sample:" & I'Img);
            end;
            delay 0.01;
         end loop;

         delay 5.0;

         Messaging.Server.Finalize (Application.Reader);
         Messaging.Client.Finalize (Application.Writer);
      end;

   end if;
end DDS.Mq.Tests.Simple.Main;
