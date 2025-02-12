Class {
	#name : #GtOpenAIMessage,
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

{ #category : #'as yet unclassified' }
GtOpenAIMessage class >> from: aDict [
	^ self new from: aDict
]

{ #category : #accessing }
GtOpenAIMessage class >> serializationProperties [
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
GtOpenAIMessage >> ancestor [
	^ self chat ancestorOf: self
]

{ #category : #accessing }
GtOpenAIMessage >> annotations [
	(content isKindOf: Dictionary) ifFalse: [ ^ GtOpenAIAnnotationsGroup new ].

	^ annotations
		ifNil: [ annotations := GtOpenAIAnnotationsGroup
					withAll: ((content select: [ :aValue | (aValue at: 'type') = 'text' ])
							flatCollect: [ :aValue | 
								(aValue at: #text at: #annotations)
									collect: [ :anAnnotation | (GtOpenAIAnnotation from: anAnnotation) client: self client ] ]) ]
]

{ #category : #accessing }
GtOpenAIMessage >> announce: anAnnouncement [
	chat announce: anAnnouncement
]

{ #category : #accessing }
GtOpenAIMessage >> assistantId [
	^ assistantId
]

{ #category : #accessing }
GtOpenAIMessage >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> attachments [
	^ attachments
]

{ #category : #accessing }
GtOpenAIMessage >> attachments: anObject [
	attachments := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> content [
	^ content
]

{ #category : #accessing }
GtOpenAIMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> contentJson [
	self contentText ifEmpty: [ ^ {} asDictionary ].
	^ STONJSON fromString: self contentText
]

{ #category : #accessing }
GtOpenAIMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtOpenAIMessage >> contentText [
	^ (content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content collect: [ :aValue | (aValue at: #text at: #value) ifNil: [ '' ] ]) ]
]

{ #category : #accessing }
GtOpenAIMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> createdAtString [
	^ nil
]

{ #category : #accessing }
GtOpenAIMessage >> createdAtString: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIMessage >> gtAnnotationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Annotations';
		priority: 2;
		object: [ self annotations ];
		view: #gtAnnotationsFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> gtMessageFilesFor: aView [
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
GtOpenAIMessage >> hasResponse [
	^ content anySatisfy: [ :aValue | (aValue at: #text at: #value) isNotEmpty ]
]

{ #category : #accessing }
GtOpenAIMessage >> hasStep [
	^ self step isNotNil
]

{ #category : #accessing }
GtOpenAIMessage >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIMessage >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> idString [
	^ nil
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> idString: anObject [
	id := anObject
]

{ #category : #testing }
GtOpenAIMessage >> isAssistantRole [
	^ self role = #assistant
]

{ #category : #testing }
GtOpenAIMessage >> isSystemRole [
	^ self role = #system
]

{ #category : #testing }
GtOpenAIMessage >> isUserRole [
	^ self role = #user
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> messageFiles [
	^ GtOpenAIFilesGroup
		withAll: (self content
				select: [ :aValue | aValue type = 'image_file' ]
				thenCollect: [ :aValue | self chat assistant client getFile: (aValue at: 'image_file' at: 'file_id') ])
]

{ #category : #accessing }
GtOpenAIMessage >> metadata [
	^ metadata
]

{ #category : #accessing }
GtOpenAIMessage >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> parse [
	^ LeParser parse: self contentText
]

{ #category : #accessing }
GtOpenAIMessage >> role [
	^ role
]

{ #category : #accessing }
GtOpenAIMessage >> role: anObject [
	role := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> runId [
	^ runId
]

{ #category : #accessing }
GtOpenAIMessage >> runId: anObject [
	runId := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> senderText [
	self isAssistantRole ifTrue: [ ^ 'Assistant' ].
	self isSystemRole ifTrue: [ ^ 'System' ].
	^ 'You'
]

{ #category : #accessing }
GtOpenAIMessage >> step [
	^ step
]

{ #category : #accessing }
GtOpenAIMessage >> step: anObject [
	step := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> threadId [
	^ threadId
]

{ #category : #accessing }
GtOpenAIMessage >> threadId: anObject [
	threadId := anObject
]
