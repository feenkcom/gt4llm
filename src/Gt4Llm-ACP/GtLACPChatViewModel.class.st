"
I adapt an ACP session for the chat interface. I cache stable user and assistant row models, retain the shared draft, expose send/stop availability and report errors. Agent execution remains owned by the session.
"
Class {
	#name : #GtLACPChatViewModel,
	#superclass : #GtLACPObject,
	#instVars : [
		'session',
		'messageCache',
		'lastError'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPChatViewModel >> canSend [
 ^ session state = #ready and: [ self draft trimBoth notEmpty ]
]

{ #category : #accessing }
GtLACPChatViewModel >> canStop [
 ^ session state = #prompting and: [
  session currentTurn notNil and: [ session currentTurn state = #running ] ]
]

{ #category : #accessing }
GtLACPChatViewModel >> draft [
 ^ session promptText
]

{ #category : #accessing }
GtLACPChatViewModel >> draft: aString [
 session promptText: aString
]

{ #category : #accessing }
GtLACPChatViewModel >> errorText [
 lastError ifNotNil: [ ^ lastError ].
 session currentTurn ifNotNil: [ :turn | turn error ifNotNil: [ :error | ^ error printString ] ].
 ^ ''
]

{ #category : #views }
GtLACPChatViewModel >> gtMessagesFor: aView [
 <gtView>
 ^ aView list title: 'Chat messages'; priority: 5; items: [ self messageViewModels ]; itemText: #label
]

{ #category : #accessing }
GtLACPChatViewModel >> initialize [
 super initialize.
 messageCache := IdentityDictionary new
]

{ #category : #accessing }
GtLACPChatViewModel >> lastError [
 ^ lastError
]

{ #category : #accessing }
GtLACPChatViewModel >> lastError: anObject [
 lastError := anObject
]

{ #category : #accessing }
GtLACPChatViewModel >> messageViewModels [
 ^ Array streamContents: [ :stream |
  session turns copy do: [ :turn |
   turn userMessages do: [ :user |
    | model |
    model := messageCache at: user ifAbsentPut: [
     GtLACPChatMessageViewModel new turn: turn; yourself ].
    model message: user.
    stream nextPut: model ].
   ((turn messages anySatisfy: [ :message | message role ~= #user ])
    or: [ turn toolCalls notEmpty or: [ turn isActive or: [ turn state = #failed ] ] ])
    ifTrue: [ | model |
     model := messageCache at: turn ifAbsentPut: [
      GtLACPChatMessageViewModel new turn: turn; yourself ].
     model message: turn assistantMessage.
     stream nextPut: model ] ] ]
]

{ #category : #actions }
GtLACPChatViewModel >> send [
 | turn |
 self canSend ifFalse: [ ^ nil ].
 lastError := nil.
 [ turn := session prompt: self draft ]
 on: Error do: [ :ex | lastError := ex messageText. session announceChanged. ^ nil ].
 self draft: ''.
 session announceChanged.
 ^ turn
]

{ #category : #accessing }
GtLACPChatViewModel >> session [
 ^ session
]

{ #category : #accessing }
GtLACPChatViewModel >> session: anObject [
 session := anObject
]

{ #category : #accessing }
GtLACPChatViewModel >> statusText [
 | pending |
 pending := session turns sum: [ :turn | turn permissionRequests count: [ :each | each state = #pending ] ].
 pending > 0 ifTrue: [ ^ session state asString, ' · awaiting permission' ].
 ^ session state asString
]

{ #category : #actions }
GtLACPChatViewModel >> stop [
 lastError := nil.
 [ session cancelTurn ] on: Error do: [ :ex | lastError := ex messageText. session announceChanged ]
]
