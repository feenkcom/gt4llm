Class {
	#name : #GtOpenAITutorWithSteps,
	#superclass : #GtOpenAIGtTutor,
	#instVars : [
		'steps'
	],
	#category : #'Gt4OpenAI-Examples'
}

{ #category : #accessing }
GtOpenAITutorWithSteps >> addStep: aStep [
	steps add: aStep
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> defaultAssistantDescription [
	^ 'Answers requests with multiple steps.'
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> defaultAssistantName [
	^ 'GT Step-wise Tutor - ' , FileLocator home basename
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> defaultInstructions [
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> initialize [
	super initialize.
	 
	steps := GtOpenAIStepsGroup new.
	files := GtOpenAIResourceFilesGroup new
]

{ #category : #accessing }
GtOpenAITutorWithSteps >> stepsDescription [
	^ '# Communication steps
' , (Character cr join: (steps collect: [ :aStep | '- ' , aStep asRuleString ]))
]
