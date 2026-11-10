Extension { #name : #RBCommentChange }

{ #category : #'*Gt4LlmCore' }
RBCommentChange >> gtLlmChangeKind [
	^ 'changed class comment'
]

{ #category : #'*Gt4LlmCore' }
RBCommentChange >> gtLlmNewSource [
	^ self comment ifNotNil: [ :aComment | aComment asString ]
]
