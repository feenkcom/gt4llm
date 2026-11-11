Extension { #name : #RBRenameClassChange }

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	"Record the rename, then the changes of the methods that reference the class"

	aChangeTargets renameClassNamed: self oldName to: self newName.
	super gtLlmAddChangeTargetsTo: aChangeTargets
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmChangeKind [
	^ 'renamed class'
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmChangeTarget [
	^ self oldName asString , ' to ' , self newName asString
]

{ #category : #'*Gt4LlmCore' }
RBRenameClassChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	"After a rename, the class change result is about the class with its new name"

	^ aCodeChangeResult isClassChangeResult
		and: [ aCodeChangeResult targetClassName asString = self newName asString ]
]
