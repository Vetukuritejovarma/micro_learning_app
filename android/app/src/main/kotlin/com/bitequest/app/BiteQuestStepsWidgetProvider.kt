package com.bitequest.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews
import android.content.SharedPreferences
import es.antonborri.home_widget.HomeWidgetProvider

class BiteQuestStepsWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.bitequest_steps_widget)
            val steps = widgetData.getString("steps", "")
            val progress = widgetData.getInt("progress", 0)
            views.setTextViewText(R.id.widget_steps, steps)
            views.setProgressBar(R.id.widget_progress, 100, progress, false)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
