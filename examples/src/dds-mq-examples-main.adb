with DDS.DomainParticipant;
with DDS.DomainParticipantFactory;
with DDS.Mq.Args;
with GNAT.Exception_Traces;
with GNAT.Traceback.Symbolic;
with Ada.Text_IO; use Ada.Text_IO;
procedure DDS.Mq.Examples.Main  is
   use DDS.Mq.Args;
begin
   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator (GNAT.Traceback.Symbolic.Symbolic_Traceback_No_Hex'Access);
   if Args.Parser.Parse then
      declare
         Library_Name : constant Dds.String := +Args.Library_Name.Get;
         Profile_Name : constant Dds.String := +Args.Profile_Name.Get;
         Topic_Name   : constant Dds.String := +Args.Topic_Name.Get;

         Factory      : constant DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;

         Participant  : DDS.DomainParticipant.Ref_Access;
         Listner      : aliased DDS.Mq.Examples.Listner;

         Writer  : DDS.Mq.Examples.Client.Ref_Access;
         Reader  : DDS.Mq.Examples.Server.Ref_Access;
         Data    : DDS.String;
      begin
         Participant := Factory.Create_Participant_With_Profile (Domain_Id    => Domain_Id.Get,
                                                                 Library_Name => Library_Name,
                                                                 Profile_Name => Profile_Name);

         Writer := Client.Create_With_Profile (Participant        => Participant,
                                               Topic_Name         => Topic_Name,
                                               Library_Name       => Library_Name,
                                               Profile_Name       => Profile_Name);

         Reader := Server.Create_With_Profile (Participant        => Participant,
                                               Listner            => Listner'Unchecked_Access,
                                               Topic_Name         => Topic_Name,
                                               Library_Name       => Library_Name,
                                               Profile_Name       => Profile_Name);
         for I in 1 .. 2 loop
            Put_Line ("sending> " &  "Sample:" & I'Img);
            Copy (Data, "Sample:" & I'Img);
            Writer.Write (Data);
            delay 1.0;
         end loop;
         Server.FINALIZE (Reader);
         Client.FINALIZE (WRITER);
      end;

   end if;
end DDS.Mq.Examples.Main;
