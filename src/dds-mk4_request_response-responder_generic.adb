pragma Ada_2012;
with DDS.DataReader;
with DDS.DataWriter;
package body Dds.Mk4_Request_Response.Responder_Generic is
   use DDS.Publisher;
   use DDS.Subscriber;

   ----------------
   -- Initialize --
   ----------------

   function Create
     (Topic_Base_Name : DDS.String;
      Participant     : not null DDS.DomainParticipant.Ref_Access;
      Publisher       : DDS.Publisher.Ref_Access  := null;
      Subscriber      : DDS.Subscriber.Ref_Access := null;
      Request_QoS     : access DDS.DataReaderQoS  := null;
      Reply_QoS       : access DDS.DataWriterQos  := null) return Ref_Access
   is
      Ret                : Ref_Access := new Ref;
      Request_Topic_Name : DDS.String := Ret.Create_Request_Topic_Name (Topic_Base_Name);
      Reply_Topic_Name   : DDS.String := Ret.Create_Reply_Topic_Name (Topic_Base_Name);
   begin
      Ret.Participant := Participant;
      if Publisher = null then
         Ret.Publisher := Participant.Get_Implicit_Publisher;
      else
         if Publisher.Get_Participant /= Participant then
            Free (Ret);
            raise Program_Error with "Publisher does not belong to Participant";
         end if;
      end if;
      if Subscriber = null then
         Ret.Subscriber := Participant.Get_Implicit_Subscriber;
      else
         if Subscriber.Get_Participant /= Participant then
            Free (Ret);
            raise Program_Error with "Subscriber does not belong to Participant";
         end if;
      end if;

      raise Program_Error with "Unimplemented procedure Initialize";
      return Ret;
   end Create;

   function Create (Topic_Base_Name  : DDS.String;
                    Participant      : not null DDS.DomainParticipant.Ref_Access;
                    Publisher        : DDS.Publisher.Ref_Access := null;
                    Subscriber       : DDS.Subscriber.Ref_Access := null;
                    Library          : DDS.String;
                    Profile          : DDS.String) return Ref_Access is
   begin
      return null;
   end;

   procedure Finalize (S : in out Ref_Access) is
   begin
      S.Participant.Delete_DataWriter (Dds.DataWriter.Ref_Access (S.Writer));
      S.Participant.Delete_DataReader (DDS.DataReader.Ref_Access (S.Reader));
      S.Participant.Delete_Topic (S.Reply_Topic);
      S.Participant.Delete_Topic (S.Request_Topic);
      Free (S);
   end;
end Dds.Mk4_Request_Response.Responder_Generic;
