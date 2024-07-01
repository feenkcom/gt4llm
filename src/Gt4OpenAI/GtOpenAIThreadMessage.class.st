Class {
	#name : #GtOpenAIThreadMessage,
	#superclass : #GtLlmEntity,
	#traits : 'TGtLlmThreadMessage',
	#classTraits : 'TGtLlmThreadMessage classTrait',
	#instVars : [
		'id',
		'createdAt',
		'threadId',
		'content',
		'assistantId',
		'runId',
		'metadata',
		'role',
		'annotations',
		'pipeline',
		'chat',
		'attachments',
		'step'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIThreadMessage class >> serializationProperties [
	^ {
		#assistant_id -> #assistantId.
		#content -> #content.
		#created_at -> #createdAt.
		#id -> #id.
		#metadata -> #metadata.
		#run_id -> #runId.
		#thread_id -> #threadId.
		#role -> #role.
		#attachments -> #attachments
	}
]

{ #category : #accessing }
GtOpenAIThreadMessage >> annotations [
	^ annotations
		ifNil: [ annotations := GtOpenAIAnnotationsGroup
					withAll: (content
							flatCollect: [ :aValue | 
								(aValue at: #text at: #annotations)
									collect: [ :anAnnotation | (GtOpenAIAnnotation from: anAnnotation) client: self client ] ]) ]
]

{ #category : #accessing }
GtOpenAIThreadMessage >> announce: anAnnouncement [
	chat announce: anAnnouncement
]

{ #category : #accessing }
GtOpenAIThreadMessage >> asChatMessage [
	^ GtLlmChatMessage
		from: {'role' -> self role.
				'content' -> self contentText} asDictionary
]

{ #category : #accessing }
GtOpenAIThreadMessage >> asViewModel [
	^ GtLlmThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
GtOpenAIThreadMessage >> assistantId [
	^ assistantId
]

{ #category : #accessing }
GtOpenAIThreadMessage >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> attachments [
	^ attachments
]

{ #category : #accessing }
GtOpenAIThreadMessage >> attachments: anObject [
	attachments := anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> codeBlocks [
	^ self parse children select: [ :aNode | aNode isKindOf: LeCodeBlockNode ]
]

{ #category : #actions }
GtOpenAIThreadMessage >> codeBlocksExecutor [
	^ GtOpenAICodeBlocksPipelineExecutor new
		codeBlocks: self codeBlocks;
		pipeline: pipeline;
		threadMessage: self
]

{ #category : #accessing }
GtOpenAIThreadMessage >> content [
	^ content
]

{ #category : #accessing }
GtOpenAIThreadMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> contentText [
	^ '' join: (content collect: [ :aValue | aValue at: #text at: #value ])
]

{ #category : #accessing }
GtOpenAIThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIThreadMessage >> createdAt: anObject [
	(anObject isKindOf: DateAndTime)
		ifTrue: [ createdAt := anObject ]
		ifFalse: [ createdAt := DateAndTime fromUnixTime: anObject ]
]

{ #category : #accessing }
GtOpenAIThreadMessage >> gtAnnotationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Annotations';
		priority: 2;
		object: [ self annotations ];
		view: #gtAnnotationsFor:
]

{ #category : #accessing }
GtOpenAIThreadMessage >> gtCodeBlocksFor: aView [
	<gtView>
	^ aView explicit
		title: 'Code blocks';
		priority: 3;
		stencil: [ BrVerticalPane new matchParent
				addChildren: (self codeBlocks
						collect: [ :aBlock | 
							| aSnippetElement aSnippetViewModel aSnippet |
							aSnippet := LePharoSnippet code: aBlock code source.
							aSnippetViewModel := aSnippet asSnippetViewModel.
							aSnippetElement := aSnippetViewModel snippetView asElement.
							aSnippetElement padding: (BlInsets all: 10).
							aSnippetElement snippetViewModel: aSnippetViewModel.
							aSnippetElement ]) ]
]

{ #category : #accessing }
GtOpenAIThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtOpenAIThreadMessage >> gtMethodsFor: aView [
	<gtView>
	^ aView explicit
		title: 'Methods';
		priority: 4;
		stencil: [ BrVerticalPane new matchParent
				addChildren: (self methods collect: [ :aMethod | aMethod coder asElement ]) ]
]

{ #category : #testing }
GtOpenAIThreadMessage >> hasResponse [
	^ content anySatisfy: [ :aValue | (aValue at: #text at: #value) isNotEmpty ]
]

{ #category : #accessing }
GtOpenAIThreadMessage >> hasStep [
	^ self step isNotNil
]

{ #category : #accessing }
GtOpenAIThreadMessage >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIThreadMessage >> id: anObject [
	id := anObject
]

{ #category : #testing }
GtOpenAIThreadMessage >> isAssistantRole [
	^ self role = #assistant
]

{ #category : #testing }
GtOpenAIThreadMessage >> isSystemRole [
	^ self role = #system
]

{ #category : #testing }
GtOpenAIThreadMessage >> isUserRole [
	^ self role = #user
]

{ #category : #accessing }
GtOpenAIThreadMessage >> metadata [
	^ metadata
]

{ #category : #accessing }
GtOpenAIThreadMessage >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> parse [
	^ LeParser parse: self contentText
]

{ #category : #accessing }
GtOpenAIThreadMessage >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtOpenAIThreadMessage >> pipeline: aPipeline [
	pipeline := aPipeline
]

{ #category : #accessing }
GtOpenAIThreadMessage >> role [
	^ role
]

{ #category : #accessing }
GtOpenAIThreadMessage >> role: anObject [
	role := anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> runId [
	^ runId
]

{ #category : #accessing }
GtOpenAIThreadMessage >> runId: anObject [
	runId := anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> step [
	^ step
]

{ #category : #accessing }
GtOpenAIThreadMessage >> step: anObject [
	step := anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> threadId [
	^ threadId
]

{ #category : #accessing }
GtOpenAIThreadMessage >> threadId: anObject [
	threadId := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIThreadMessage >> viewObjectFor: anObject [
	^ GtLlmViewObject new
		instance: self chat checkerInstance;
		view: anObject;
		threadMessage: self
]
