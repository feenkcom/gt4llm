"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPProtocolTranscript,
	#superclass : #GtLACPObject,
	#instVars : [
		'messages'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #views }
GtLACPProtocolTranscript >> gtMessagesFor: aView [
 <gtView>
 ^ aView columnedList
  title: 'History';
  priority: 5;
  items: [ messages copy ];
  column: 'Time' text: [ :message | message timestamp asTime printString ] width: 110;
  column: 'Direction' text: #direction width: 85;
  column: 'Type' text: #kind width: 90;
  column: 'ID' text: [ :message | message id ifNil: [ '' ] ] width: 90;
  column: 'Operation' text: #operation;
  column: 'Session' text: [ :message | message sessionId ifNil: [ '' ] ];
  send: #yourself;
  actionUpdateButtonTooltip: 'Refresh connection history'
]

{ #category : #accessing }
GtLACPProtocolTranscript >> initialize [
 super initialize.
 messages := OrderedCollection new
]

{ #category : #accessing }
GtLACPProtocolTranscript >> messages [
 ^ messages
]

{ #category : #accessing }
GtLACPProtocolTranscript >> messages: anObject [
 messages := anObject
]

{ #category : #recording }
GtLACPProtocolTranscript >> record: aDictionary direction: aSymbol [
 messages add: (GtLACPProtocolMessage new
  data: aDictionary deepCopy;
  direction: aSymbol;
  timestamp: DateAndTime now;
  yourself)
]
