Class {
	#name : #GtOpenAIBlogPostMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #Gt4OpenAI
}

{ #category : #views }
GtOpenAIBlogPostMessage >> gtPostFor: aView [
	<gtView>
	<gtLlmMessageView>
	| json |
	[ json := self contentJson ] on: Error do: [ ^ aView empty ].
	json at: 'Post' ifAbsent: [ ^ aView empty ].
	^ aView textEditor
		title: 'Post';
		priority: 1;
		text: [ json at: 'Post' ]
]
