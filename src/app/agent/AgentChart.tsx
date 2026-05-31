'use client';

import {
  Area,
  AreaChart,
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Legend,
  Line,
  LineChart,
  Pie,
  PieChart,
  PolarAngleAxis,
  PolarGrid,
  PolarRadiusAxis,
  Radar,
  RadarChart,
  ResponsiveContainer,
  Scatter,
  ScatterChart,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts';

import type { AgentChart as AgentChartSpec } from '@/lib/erp-agent-chart';

const chartColors = ['#0891b2', '#2563eb', '#0f766e', '#ea580c'];

const cartesianAxis = (chart: AgentChartSpec) => (
  <>
    <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
    <XAxis dataKey={chart.xKey} tick={{ fontSize: 11 }} />
    <YAxis tick={{ fontSize: 11 }} />
    <Tooltip />
    <Legend />
  </>
);

export default function AgentChart({ chart }: { chart: AgentChartSpec }) {
  const renderChart = () => {
    if (chart.type === 'bar') {
      return (
        <BarChart data={chart.data}>
          {cartesianAxis(chart)}
          {chart.series.map((series, index) => (
            <Bar key={series.key} dataKey={series.key} name={series.label} fill={chartColors[index]} radius={[5, 5, 0, 0]} />
          ))}
        </BarChart>
      );
    }

    if (chart.type === 'line') {
      return (
        <LineChart data={chart.data}>
          {cartesianAxis(chart)}
          {chart.series.map((series, index) => (
            <Line key={series.key} dataKey={series.key} name={series.label} stroke={chartColors[index]} strokeWidth={2.5} />
          ))}
        </LineChart>
      );
    }

    if (chart.type === 'area') {
      return (
        <AreaChart data={chart.data}>
          {cartesianAxis(chart)}
          {chart.series.map((series, index) => (
            <Area
              key={series.key}
              dataKey={series.key}
              name={series.label}
              fill={chartColors[index]}
              fillOpacity={0.18}
              stroke={chartColors[index]}
              strokeWidth={2}
            />
          ))}
        </AreaChart>
      );
    }

    if (chart.type === 'pie') {
      const series = chart.series[0];
      return (
        <PieChart>
          <Pie data={chart.data} dataKey={series.key} nameKey={chart.xKey} innerRadius={45} outerRadius={90} paddingAngle={2}>
            {chart.data.map((row, index) => (
              <Cell key={`${row[chart.xKey]}-${index}`} fill={chartColors[index % chartColors.length]} />
            ))}
          </Pie>
          <Tooltip />
          <Legend />
        </PieChart>
      );
    }

    if (chart.type === 'scatter') {
      const series = chart.series[0];
      return (
        <ScatterChart>
          <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
          <XAxis dataKey={chart.xKey} name={chart.xKey} tick={{ fontSize: 11 }} />
          <YAxis dataKey={series.key} name={series.label} tick={{ fontSize: 11 }} />
          <Tooltip cursor={{ strokeDasharray: '3 3' }} />
          <Scatter data={chart.data} name={series.label} fill={chartColors[0]} />
        </ScatterChart>
      );
    }

    return (
      <RadarChart data={chart.data}>
        <PolarGrid />
        <PolarAngleAxis dataKey={chart.xKey} tick={{ fontSize: 11 }} />
        <PolarRadiusAxis tick={{ fontSize: 11 }} />
        {chart.series.map((series, index) => (
          <Radar
            key={series.key}
            dataKey={series.key}
            name={series.label}
            fill={chartColors[index]}
            fillOpacity={0.12}
            stroke={chartColors[index]}
            strokeWidth={2}
          />
        ))}
        <Legend />
        <Tooltip />
      </RadarChart>
    );
  };

  return (
    <div className="mt-3 rounded-xl border border-slate-200 bg-slate-50 p-3 sm:p-4">
      <h3 className="mb-3 text-sm font-semibold text-slate-800">{chart.title}</h3>
      <div className="h-72 w-full min-w-[280px]">
        <ResponsiveContainer width="100%" height="100%">
          {renderChart()}
        </ResponsiveContainer>
      </div>
    </div>
  );
}
