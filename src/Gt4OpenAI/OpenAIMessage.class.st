Class {
	#name : #OpenAIMessage,
	#superclass : #GtLlmChatMessage,
	#traits : 'TGtLlmThreadMessage',
	#classTraits : 'TGtLlmThreadMessage classTrait',
	#instVars : [
		'threadId',
		'assistantId',
		'runId',
		'metadata',
		'annotations',
		'pipeline',
		'step'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
OpenAIMessage class >> serializationProperties [
	^ {
		#assistant_id -> #assistantId.
		#content -> #content.
		#created_at -> #createdAtString.
		#id -> #idString.
		#metadata -> #metadata.
		#run_id -> #runId.
		#thread_id -> #threadId.
		#role -> #role.
		#attachments -> #attachments
	}
]

{ #category : #accessing }
OpenAIMessage >> ancestor [
	^ self chat ancestorOf: self
]

{ #category : #accessing }
OpenAIMessage >> annotations [
	(content isKindOf: Dictionary) ifFalse: [ ^ GtOpenAIAnnotationsGroup new ].

	^ annotations
		ifNil: [ annotations := GtOpenAIAnnotationsGroup
					withAll: ((content select: [ :aValue | (aValue at: 'type') = 'text' ])
							flatCollect: [ :aValue | 
								(aValue at: #text at: #annotations)
									collect: [ :anAnnotation | (GtOpenAIAnnotation from: anAnnotation) client: self client ] ]) ]
]

{ #category : #accessing }
OpenAIMessage >> announce: anAnnouncement [
	chat announce: anAnnouncement
]

{ #category : #accessing }
OpenAIMessage >> asViewModel [
	^ GtLlmThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
OpenAIMessage >> assistantId [
	^ assistantId
]

{ #category : #accessing }
OpenAIMessage >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
OpenAIMessage >> attachments [
	^ attachments
]

{ #category : #accessing }
OpenAIMessage >> attachments: anObject [
	attachments := anObject
]

{ #category : #accessing }
OpenAIMessage >> chat [
	^ chat
]

{ #category : #accessing }
OpenAIMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
OpenAIMessage >> content [
	^ content
]

{ #category : #accessing }
OpenAIMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
OpenAIMessage >> contentJson [
	self contentText ifEmpty: [ ^ {} asDictionary ].
	^ STONJSON fromString: self contentText
]

{ #category : #accessing }
OpenAIMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
OpenAIMessage >> contentText [
	^ (content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content collect: [ :aValue | (aValue at: #text at: #value) ifNil: [ '' ] ]) ]
]

{ #category : #accessing }
OpenAIMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
OpenAIMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #'as yet unclassified' }
OpenAIMessage >> createdAtString [
	^ nil
]

{ #category : #accessing }
OpenAIMessage >> createdAtString: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
OpenAIMessage >> gtActionInspectFor: anAction [
	<gtLlmAction>
	^ super gtActionInspectFor: anAction
]

{ #category : #accessing }
OpenAIMessage >> gtAnnotationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Annotations';
		priority: 2;
		object: [ self annotations ];
		view: #gtAnnotationsFor:
]

{ #category : #accessing }
OpenAIMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
OpenAIMessage >> gtJsonDataFor: aView context: aContext [
	<gtView>
	<gtLlmMessageView>
	self chat responseFormat ifNil: [ ^ aView empty ].
	self contentText ifEmpty: [ ^ aView empty ].

	^ (self contentJson gtTreeFor: aView context: aContext)
		title: 'JSON data';
		priority: 4.5
]

{ #category : #accessing }
OpenAIMessage >> gtJsonFor: aView [
	<gtView>
	self chat responseFormat ifNil: [ ^ aView empty ].
	self isAssistantRole ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'JSON';
		priority: 4;
		text: [ self contentText ];
		styler: JSONParser gtStyler;
		aptitude: BrGlamorousCodeEditorAptitude
]

{ #category : #'as yet unclassified' }
OpenAIMessage >> gtMessageFilesFor: aView [
	<gtView>
	<gtLlmMessageView>
	| messageFiles |
	messageFiles := self messageFiles.

	messageFiles ifEmpty: [ ^ aView empty ].

	"for some reason we need this instead of a forward for the layout in the message to work"
	^ (messageFiles gtFilesFor: aView) 
		title: 'Message files';
		priority: 10
]

{ #category : #testing }
OpenAIMessage >> hasResponse [
	^ content anySatisfy: [ :aValue | (aValue at: #text at: #value) isNotEmpty ]
]

{ #category : #accessing }
OpenAIMessage >> hasStep [
	^ self step isNotNil
]

{ #category : #accessing }
OpenAIMessage >> id [
	^ id
]

{ #category : #accessing }
OpenAIMessage >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
OpenAIMessage >> idString [
	^ nil
]

{ #category : #'as yet unclassified' }
OpenAIMessage >> idString: anObject [
	id := anObject
]

{ #category : #testing }
OpenAIMessage >> isAssistantRole [
	^ self role = #assistant
]

{ #category : #testing }
OpenAIMessage >> isSystemRole [
	^ self role = #system
]

{ #category : #testing }
OpenAIMessage >> isUserRole [
	^ self role = #user
]

{ #category : #'as yet unclassified' }
OpenAIMessage >> messageFiles [
	^ GtOpenAIFilesGroup
		withAll: (self content
				select: [ :aValue | aValue type = 'image_file' ]
				thenCollect: [ :aValue | self chat assistant client getFile: (aValue at: 'image_file' at: 'file_id') ])
]

{ #category : #accessing }
OpenAIMessage >> metadata [
	^ metadata
]

{ #category : #accessing }
OpenAIMessage >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
OpenAIMessage >> parse [
	^ LeParser parse: self contentText
]

{ #category : #accessing }
OpenAIMessage >> role [
	^ role
]

{ #category : #accessing }
OpenAIMessage >> role: anObject [
	role := anObject
]

{ #category : #accessing }
OpenAIMessage >> runId [
	^ runId
]

{ #category : #accessing }
OpenAIMessage >> runId: anObject [
	runId := anObject
]

{ #category : #accessing }
OpenAIMessage >> senderText [
	self isAssistantRole ifTrue: [ ^ 'Assistant' ].
	self isSystemRole ifTrue: [ ^ 'System' ].
	^ 'You'
]

{ #category : #accessing }
OpenAIMessage >> step [
	^ step
]

{ #category : #accessing }
OpenAIMessage >> step: anObject [
	step := anObject
]

{ #category : #accessing }
OpenAIMessage >> threadId [
	^ threadId
]

{ #category : #accessing }
OpenAIMessage >> threadId: anObject [
	threadId := anObject
]
