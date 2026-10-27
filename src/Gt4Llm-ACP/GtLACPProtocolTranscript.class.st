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
 ^ aView list title: 'Messages'; priority: 5; items: [ messages copy ]; itemText: #summary; actionUpdateButtonTooltip: 'Refresh messages'
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
 messages add: (GtLACPProtocolMessage new data: aDictionary; direction: aSymbol; timestamp: DateAndTime now; yourself)
]
