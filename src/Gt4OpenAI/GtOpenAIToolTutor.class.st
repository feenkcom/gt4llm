Class {
	#name : #GtOpenAIToolTutor,
	#superclass : #GtOpenAIGtTutor,
	#instVars : [
		'tutorTools'
	],
	#category : #'Gt4OpenAI-Examples'
}

{ #category : #accessing }
GtOpenAIToolTutor >> addTool: aTool [
	tutorTools add: aTool
]

{ #category : #accessing }
GtOpenAIToolTutor >> defaultAssistantDescription [
	^ 'Uses tools and answers requests.'
]

{ #category : #accessing }
GtOpenAIToolTutor >> defaultAssistantName [
	^ 'GT Tool Tutor - ' , FileLocator home basename
]

{ #category : #accessing }
GtOpenAIToolTutor >> defaultInstructions [
]

{ #category : #accessing }
GtOpenAIToolTutor >> initialize [
	super initialize.
	
	tutorTools := GtOpenAIToolsGroup new.
	files := GtOpenAIResourceFilesGroup new
]

{ #category : #accessing }
GtOpenAIToolTutor >> instructions [
	^ 'You have access to the following tools to help solve the TASK given to you:
{1}

If you decide to use a tool, you MUST use exactly the following JSON format, with no additional text before or after it:

```tool
\{
	"type": "Step",
	"tool": "... One of the tools from above ...",
	"input": ... the input to the tool ...
}
```

When you are done, or when you don’t need to use a tool to finish the task, you MUST send the following JSON response with no surrounding text:

```
\{
	"type": "Done",
	"answer: "... your response ..."
}
```

Do NOT output in any other format.
' format: {tutorTools serialize}
]
