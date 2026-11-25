Extension { #name : #RBCommentChange }

{ #category : #'*Gt4LlmCore' }
RBCommentChange >> gtLlmChangeKind [
	^ 'changed class comment'
]

{ #category : #'*Gt4LlmCore' }
RBCommentChange >> gtLlmNewChangeEntry [
	"The new comment is the new source of the entry"

	^ GtLRefactoringClassChangeEntry new
		className: self changeClassName asString;
		yourself
]

{ #category : #'*Gt4LlmCore' }
RBCommentChange >> gtLlmNewSource [
	^ self comment ifNotNil: [ :aComment | aComment asString ]
]
