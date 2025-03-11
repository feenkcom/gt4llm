Class {
	#name : #GtOpenAIBlogPostMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #Gt4OpenAI
}

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> actionModel [
	^ (self chat tutor actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> contentSummary [
	^ self action
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

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

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> gtPromoteToExampleActionFor: anAction [
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Promote example';
		content: [ :aButton | 
			| action example |
			action := self chat tutor actionNamed: self action.
			example := GtLlmTutorActionExample new
					input: self ancestor contentJson;
					output: self contentJson.
			action addExample: example.
			action persist.
			example asGtMagritteViewModel asElement ]
]

{ #category : #'trait-TGtActionMessage' }
GtOpenAIBlogPostMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
