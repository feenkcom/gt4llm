Class {
	#name : #GtOpenAIThreadMessage,
	#superclass : #GtOpenAIEntity,
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
		'pipeline',
		'chat'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIThreadMessage class >> serializationProperties [
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
GtOpenAIThreadMessage >> annotations [
	^ annotations
		ifNil: [ annotations := GtOpenAIAnnotationsGroup
					withAll: (content
							flatCollect: [ :aValue | 
								(aValue at: #text at: #annotations)
									collect: [ :anAnnotation | (GtOpenAIAnnotation from: anAnnotation) client: self client ] ]) ]
]

{ #category : #accessing }
GtOpenAIThreadMessage >> asChatMessage [
	^ GtOpenAIChatMessage
		from: {'role' -> self role.
				'content' -> self contentText} asDictionary
]

{ #category : #accessing }
GtOpenAIThreadMessage >> asViewModel [
	^ GtOpenAIThreadMessageViewModel new threadMessage: self
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
GtOpenAIThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #actions }
GtOpenAIThreadMessage >> codeBlockChecker [
	^ GtOpenAICodeBlocksChecker new
		codeBlocks: self codeBlocks;
		pipeline: pipeline
]

{ #category : #accessing }
GtOpenAIThreadMessage >> codeBlocks [
	^ self parse children
		select: [ :aNode | (aNode isKindOf: LeCodeBlockNode) and: [ aNode isForSmalltalk ] ]
		thenCollect: [ :aNode | aNode code value ]
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
	createdAt := DateAndTime fromUnixTime: anObject
]

{ #category : #accessing }
GtOpenAIThreadMessage >> fileIds [
	^ fileIds
]

{ #category : #accessing }
GtOpenAIThreadMessage >> fileIds: anObject [
	fileIds := anObject
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
						collect: [ :aText | 
							| aSnippetElement aSnippetViewModel aSnippet |
							aSnippet := LePharoSnippet code: aText.
							aSnippetViewModel := aSnippet asSnippetViewModel.
							aSnippetElement := aSnippetViewModel snippetView asElement.
							aSnippetElement padding: (BlInsets all: 10).
							aSnippetElement snippetViewModel: aSnippetViewModel.
							aSnippetElement ]) ]
]

{ #category : #accessing }
GtOpenAIThreadMessage >> gtContentFor: aView [
	<gtView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [
			(GtOpenAIThreadMessageElement new threadMessageViewModel: self asViewModel) asScrollableElement
		]
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
GtOpenAIThreadMessage >> methods [
	^ self parse children
		select: [ :aNode | 
			(aNode isKindOf: LeCodeBlockNode)
				and: [ aNode isForLanguage: 'smalltalk-method' ] ]
		thenCollect: [ :aNode | |aString |aString := aNode code value trim.
			GtLlmMessageMethod new
				methodClass: aString lines first asClass;
				methodBody: (Character lf join: aString lines allButFirst) ]
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
GtOpenAIThreadMessage >> threadId [
	^ threadId
]

{ #category : #accessing }
GtOpenAIThreadMessage >> threadId: anObject [
	threadId := anObject
]
