with DDS.DomainParticipant;
with DDS.DomainParticipantFactory;
with DDS.Mq.Args;
with GNAT.Exception_Traces;
with GNAT.Traceback.Symbolic;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;
procedure DDS.Mq.Tests_Simple.Main  is
   use DDS.Mq.Args;
   use Ada.Strings.Fixed;
begin

   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);

   if Args.Parser.Parse then
      declare
         Topic_Name   : constant DDS.String := +Args.Topic_Name.Get;
         Topic_Qos    : DDS.TopicQos;

      begin
         Writer := Client.Create (Topic_Name => Topic_Name);
         Reader := Server.Create
           (Listner    => Listner'Unchecked_Access,
            Topic_Name => Topic_Name);
         delay 1.0;
         for I in 1 .. 100 loop
            Put_Line ("sending> " &  "Sample:" & I'Img);
            Move ("Sample:" & I'Img, Data.Name);
            Data.Name_Last := I;
            begin
               Writer.Write (Data);
            exception
               when DDS.TIMEOUT =>
                  Put_Line ("Unable to send> " &  "Sample:" & I'Img);
            end;
            delay 0.01;
         end loop;

         delay 5.0;

         Server.Finalize (Reader);
         Client.Finalize (Writer);
      end;

   end if;
end DDS.Mq.Tests_Simple.Main;
