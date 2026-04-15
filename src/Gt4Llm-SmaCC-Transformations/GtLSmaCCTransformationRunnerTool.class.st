Class {
	#name : #GtLSmaCCTransformationRunnerTool,
	#superclass : #GtLSmaCCTransformationTool,
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationRunnerTool >> description [
	^ 'Runs a rewrite file on a sample source file and returns the transformed file.
	
Example JSON arguments:
{
	"filename": "./directory/rewrites.rw",
	"source": "for (i = 0; i < 10; i++) console.log(i);",
	"parser": "JSParser"
}

Example JSON response:
{
	"newSource": "i = 0;\nwhile (i<10) {\n\tconsole.log(i);\n\ti++;\n}"
}
'
]

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationRunnerTool >> name [
	^ 'runSmaCCRewrites'
]

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationRunnerTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments runner |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	runner := arguments
			at: 'runner'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'runner' ].
	runner model: model.
	^ runner runRewrites
]

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationRunnerTool >> runnerDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #runner;
		classes: {GtLSmaCCTransformationRunner};
		beRequired
]
