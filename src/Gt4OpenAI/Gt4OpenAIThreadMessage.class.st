Class {
	#name : #Gt4OpenAIThreadMessage,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'id',
		'createdAt',
		'threadId',
		'content',
		'fileIds',
		'assistantId',
		'runId',
		'metadata',
		'role',
		'annotations',
		'executor',
		'chat'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIThreadMessage class >> serializationProperties [
	^ {
		#assistant_id -> #assistantId.
		#content -> #content.
		#created_at -> #createdAt.
		#file_ids -> #fileIds.
		#id -> #id.
		#metadata -> #metadata.
		#run_id -> #runId.
		#thread_d -> #threadId.
		#role -> #role
	}
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> annotations [
	^ annotations
		ifNil: [ annotations := Gt4OpenAIAnnotationsGroup
					withAll: (content
							flatCollect: [ :aValue | 
								(aValue at: #text at: #annotations)
									collect: [ :anAnnotation | (Gt4OpenAIAnnotation from: anAnnotation) client: self client ] ]) ]
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> asChatMessage [
	^ Gt4OpenAIChatMessage
		from: {'role' -> self role.
				'content' -> self contentText} asDictionary
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> assistantId [
	^ assistantId
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #actions }
Gt4OpenAIThreadMessage >> codeBlockExecutor [
	^ Gt4OpenAICodeBlocksExecutor new
		codeBlocks: self codeBlocks;
		codeExecutor: self executor;
		chat: self chat;
		maximumMessageSize: self maximumMessageSize
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> codeBlocks [
	^ self parse children
		select: [ :aNode | (aNode isKindOf: LeCodeBlockNode) and: [ aNode isForSmalltalk ] ]
		thenCollect: [ :aNode | aNode code value ]
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> content [
	^ content
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> contentText [
	^ '' join: (content collect: [ :aValue | aValue at: #text at: #value ])
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> createdAt: anObject [
	createdAt := DateAndTime fromUnixTime: anObject
]

{ #category : #ui }
Gt4OpenAIThreadMessage >> elementClass [
	^ Gt4OpenAIThreadMessageElement
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> executor [
	^ executor
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> executor: anExecutor [
	executor := anExecutor
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> fileIds [
	^ fileIds
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> fileIds: anObject [
	fileIds := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> gtAnnotationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Annotations';
		priority: 2;
		object: [ self annotations ];
		view: #gtAnnotationsFor:
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> gtCodeBlocksFor: aView [
	<gtView>
	^ aView explicit
		title: 'Code blocks';
		priority: 3;
		stencil: [ BrVerticalPane new matchParent
				addChildren: (self codeBlocks
						collect: [ :aText | 
							| aSnippetElement aSnippetViewModel aSnippet |
							aSnippet := LePharoSnippet code: aText.
							aSnippetViewModel := aSnippet asSnippetViewModel.
							aSnippetElement := aSnippetViewModel snippetView asElement.
							aSnippetElement padding: (BlInsets all: 10).
							aSnippetElement snippetViewModel: aSnippetViewModel.
							aSnippetElement ]) ];
		actionButtonIcon: BrGlamorousVectorIcons play
			label: 'Run all'
			tooltip: 'Execute all snippets (assuming all are Pharo snippets)'
			action: [ :aButton | 
				| aCodeExecutor |
				aButton
					withAsyncFutureDo: [ :anElementFuture | 
						anElementFuture
							whenPending: [ :theButton | 
								theButton
									disable;
									label: 'Running...' ];
							whenError: [ :theButton :anError | 
								theButton
									enable;
									label: 'Execution error' ];
							whenSuccess: [ :theButton :aResult | 
								theButton
									enable;
									label: 'Finished' ].

						aCodeExecutor := self codeBlockExecutor.
						anElementFuture future: aCodeExecutor future ] ]
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> gtContentFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self contentText ];
		styler: self styler 
]

{ #category : #testing }
Gt4OpenAIThreadMessage >> hasResponse [
	^ content anySatisfy: [ :aValue | (aValue at: #text at: #value) isNotEmpty ]
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> id: anObject [
	id := anObject
]

{ #category : #testing }
Gt4OpenAIThreadMessage >> isAssistantRole [
	^ self role = #assistant
]

{ #category : #testing }
Gt4OpenAIThreadMessage >> isUserRole [
	^ self role = #user
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> maximumMessageSize [
	^ 30000
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> metadata [
	^ metadata
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> parse [
	^ LeParser parse: self contentText
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> role [
	^ role
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> role: anObject [
	role := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> runId [
	^ runId
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> runId: anObject [
	runId := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> styler [
	^ BlCompositeStyler new
		stylers: {LeSnippetStyler new
					snippetViewModel: (LeTextSnippet string: self) asSnippetViewModel.
				Gt4OpenAITraceStyler new.
				Gt4OpenAIThreadMessageStyler new annotations: self annotations}
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> threadId [
	^ threadId
]

{ #category : #accessing }
Gt4OpenAIThreadMessage >> threadId: anObject [
	threadId := anObject
]
