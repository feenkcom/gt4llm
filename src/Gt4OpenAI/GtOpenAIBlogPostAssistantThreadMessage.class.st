Class {
	#name : #GtOpenAIBlogPostAssistantThreadMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistantThreadMessage >> blogPost [
	^ self contentJson at: 'Blog post' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistantThreadMessage >> gtBlogPostFor: aView [
	<gtView>
	<gtLlmMessageView>
	self blogPost ifEmpty: [ ^ aView empty ].

	^ aView textEditor
		title: 'Blog post';
		priority: 1;
		text: [ self blogPost ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Update blog post'
			action: [ :aButton | aButton parent parent parent parent
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | 
						self chat pipeline instance content: anEditor text asString ] ]
]
