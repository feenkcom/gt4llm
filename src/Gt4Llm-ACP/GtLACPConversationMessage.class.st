Class {
	#name : #GtLACPConversationMessage,
	#superclass : #GtLACPObject,
	#instVars : [
		'role',
		'messageId',
		'content',
		'protocolMetadata',
		'lastReceivedUpdate'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #converting }
GtLACPConversationMessage >> addWorkElementsTo: elements in: aWorkElement [
	aWorkElement addCommentElementFor: self to: elements
]

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

{ #category : #accessing }
GtLACPConversationMessage >> contextUsageUpdate [
	^ lastReceivedUpdate ifNotNil: [ lastReceivedUpdate contextUsageUpdate ]
]

{ #category : #accessing }
GtLACPConversationMessage >> contextWindow [
	^ self hasContextUsageUpdate
		ifTrue: [ self contextUsageUpdate contextWindow ]
		ifFalse: [ GtLACPContextWindow new ]
]

{ #category : #views }
GtLACPConversationMessage >> gtContentFor: aView [
 <gtView>
 ^ aView list title: 'Content blocks'; priority: 20; items: [ content copy ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh content blocks'
]

{ #category : #'gt - views' }
GtLACPConversationMessage >> gtContextUsageFor: aView [
	"What raw usage report was known when this message's last chunk arrived?"

	<gtView>
	^ aView columnedList
		title: 'Context evidence';
		priority: 15;
		items: [ self hasContextUsageUpdate
				ifFalse: [ {'Context' -> 'Not reported'} ]
				ifTrue: [ self contextUsageUpdate data associations ] ];
		column: 'Property' text: #key;
		column: 'Value' text: [ :entry | entry value asString ];
		send: #value
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
		text: [ GtLMessageStyler new privateStyle: self text asRopedText ];
		actionUpdateButtonTooltip: 'Refresh text'
]

{ #category : #testing }
GtLACPConversationMessage >> hasContextUsageUpdate [
	^ self contextUsageUpdate notNil
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
GtLACPConversationMessage >> lastReceivedUpdate [
	^ lastReceivedUpdate
]

{ #category : #accessing }
GtLACPConversationMessage >> lastReceivedUpdate: anUpdate [
	"Retain raw reception evidence, never an interpreted context window."

	lastReceivedUpdate := anUpdate
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
	protocolMetadata := aDictionary
			ifNil: [ Dictionary new ]
			ifNotNil: [ :aMetadata | aMetadata deepCopy ]
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
