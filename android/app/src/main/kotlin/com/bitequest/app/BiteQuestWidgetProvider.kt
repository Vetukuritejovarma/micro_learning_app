package com.bitequest.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews
import android.content.SharedPreferences
import es.antonborri.home_widget.HomeWidgetProvider

class BiteQuestWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.bitequest_widget)
            val xp = widgetData.getInt("xp", 0)
            val streak = widgetData.getInt("streak", 0)
            views.setTextViewText(R.id.widget_xp, "XP $xp")
            views.setTextViewText(R.id.widget_streak, "Streak $streak")
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
