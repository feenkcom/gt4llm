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
GtOpenAIBlogPostAssistantThreadMessage >> diff [
	^ TextDiffBuilder from: self chat pipeline instance content to: self blogPost
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistantThreadMessage >> gtBlogPostDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	self blogPost ifEmpty: [ ^ aView empty ].
	self isUserRole ifTrue: [ ^ aView empty ].
	self action = 'Review the blog post' ifFalse: [ ^ aView empty ].
	
	^ aView explicit
		title: 'Blog post diff';
		priority: 1;
		stencil: [ (GtDiffElement onDiff: self diff) ]
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistantThreadMessage >> gtBlogPostFor: aView [
	<gtView>
	<gtLlmMessageView>
	self blogPost ifEmpty: [ ^ aView empty ].
	self action = 'Review the blog post' ifFalse: [ ^ aView empty ].
	
	^ aView textEditor
		title: 'Blog post';
		priority: 1;
		text: [ self blogPost ];
		styler: (GtLlmMessageStyler new threadMessageViewModel: self asViewModel);
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Update blog post'
			action: [ :aButton | aButton parent parent parent parent
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | 
						self chat pipeline instance content: anEditor text asString ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistantThreadMessage >> gtReviewFor: aView [
	<gtView>
	<gtLlmMessageView>
	self review isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Review';
		priority: 2;
		text: [ self review ];
		styler: (GtLlmMessageStyler new threadMessageViewModel: self asViewModel)
]

{ #category : #'as yet unclassified' }
GtOpenAIBlogPostAssistantThreadMessage >> review [
	^ self contentJson at: 'Review' ifAbsent: [ '' ]
]
