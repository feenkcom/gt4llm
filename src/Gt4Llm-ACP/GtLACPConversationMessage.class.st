"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPConversationMessage,
	#superclass : #GtLACPObject,
	#instVars : [
		'role',
		'messageId',
		'content',
		'protocolMetadata'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #converting }
GtLACPConversationMessage >> asConversationTreeNode [
 ^ GtLACPMessageTreeNode new object: self; yourself
]

{ #category : #accessing }
GtLACPConversationMessage >> content [
 ^ content
]

{ #category : #accessing }
GtLACPConversationMessage >> content: anObject [
 content := anObject
]

{ #category : #views }
GtLACPConversationMessage >> gtContentFor: aView [
 <gtView>
 ^ aView list title: 'Content blocks'; priority: 20; items: [ content copy ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh content blocks'
]

{ #category : #views }
GtLACPConversationMessage >> gtProtocolFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Protocol';
		priority: 5;
		items: [ {'Role' -> role.
				'Message ID' -> messageId.
				'Metadata' -> self protocolMetadata} ];
		column: 'Field' text: #key;
		column: 'Value' text: [ :each | each value printString ];
		send: #value
]

{ #category : #views }
GtLACPConversationMessage >> gtTextFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Text';
		priority: 1;
		text: [ | text styler |
			text := self text asRopedText.
			styler := GtLMessageStyler new.
			styler privateStyle: text.
			text ];
		actionUpdateButtonTooltip: 'Refresh text'
]

{ #category : #accessing }
GtLACPConversationMessage >> initialize [
 super initialize.
 content := OrderedCollection new
]

{ #category : #testing }
GtLACPConversationMessage >> isInterSessionMessage [
 ^ false
]

{ #category : #accessing }
GtLACPConversationMessage >> messageId [
 ^ messageId
]

{ #category : #accessing }
GtLACPConversationMessage >> messageId: anObject [
 messageId := anObject
]

{ #category : #accessing }
GtLACPConversationMessage >> printOn: aStream [
 aStream nextPutAll: role asString; nextPutAll: ': '; nextPutAll: self text
]

{ #category : #accessing }
GtLACPConversationMessage >> protocolMetadata [
 ^ protocolMetadata ifNil: [ protocolMetadata := Dictionary new ]
]

{ #category : #accessing }
GtLACPConversationMessage >> protocolMetadata: aDictionary [
 protocolMetadata := aDictionary ifNil: [ Dictionary new ] ifNotNil: #deepCopy
]

{ #category : #accessing }
GtLACPConversationMessage >> role [
 ^ role
]

{ #category : #accessing }
GtLACPConversationMessage >> role: anObject [
 role := anObject
]

{ #category : #accessing }
GtLACPConversationMessage >> text [
 ^ String streamContents: [ :stream | content do: [ :each | stream nextPutAll: each text ] ]
]

{ #category : #accessing }
GtLACPConversationMessage >> workSummaryText [
 ^ self text
]
