Extension { #name : #RBRenameVariableChange }

{ #category : #'*Gt4LlmCore' }
RBRenameVariableChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	"Record the class defining the variable, then the changes of the methods that reference it"

	aChangeTargets addClassNamed: self changeClassName.
	super gtLlmAddChangeTargetsTo: aChangeTargets
]

{ #category : #'*Gt4LlmCore' }
RBRenameVariableChange >> gtLlmChangeKind [
	^ 'renamed variable'
]

{ #category : #'*Gt4LlmCore' }
RBRenameVariableChange >> gtLlmChangeTarget [
	"A variable belongs to its class, so the class is the target; the variable names are in the change description"

	^ self displayClassName asString
]

{ #category : #'*Gt4LlmCore' }
RBRenameVariableChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	^ aCodeChangeResult isClassChangeResult
		and: [ aCodeChangeResult targetClassName asString = self changeClassName asString ]
]

{ #category : #'*Gt4LlmCore' }
RBRenameVariableChange >> gtLlmPreviewChanges [
	"Describe the rename and the methods it rewrites, which are nested in it"

	^ {GtLRefactoringChange fromChange: self}
		, (self changes
				flatCollect: [ :eachChange | 
					eachChange gtBasicChanges
						collect: [ :eachBasicChange | GtLRefactoringChange fromChange: eachBasicChange ] ])
				asArray
]
