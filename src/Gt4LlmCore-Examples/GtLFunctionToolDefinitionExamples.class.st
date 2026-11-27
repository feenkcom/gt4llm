"
I show how the function tools are defined for models and clients (functionMCP, functionOpenAI, functionAnthropic, functionGemini).
"
Class {
	#name : #GtLFunctionToolDefinitionExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLFunctionToolDefinitionExamples >> descriptionsHaveLineFeeds [
	"The tool definitions give the descriptions with line feeds as line ends, whatever the line ends of the method source: a description written as a multi-line literal keeps its line breaks, as line feeds"

	<gtExample>
	| aTool definitions tools |
	aTool := GtLToolForApplyRefactoring new.
	self assert: (aTool description includes: Character cr).
	definitions := {aTool functionMCP.
			aTool functionOpenAI.
			aTool functionAnthropic.
			aTool functionGemini}.
	self
		assert: (definitions
				allSatisfy: [ :each | 
					| aDescription |
					aDescription := each at: 'description'.
					(aDescription includes: Character cr) not
						and: [ (aDescription occurrencesOf: Character lf)
								= (aTool description lines size - 1) ] ]).
	tools := GtLTools gt select: [ :each | each isKindOf: GtLAbstractFunctionTool ].
	self assert: tools notEmpty.
	self
		assert: (tools
				allSatisfy: [ :each | ((each functionMCP at: 'description') includes: Character cr) not ]).
	^ definitions
]
