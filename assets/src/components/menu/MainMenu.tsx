import { dashboard_path, org_path, contact_path, report_path } from "@/routes"

import MainMenuItem from "@/components/menu/MainMenuItem"
import { Building, CircleGauge, Printer, Users } from "lucide-react"

interface Props {
  className?: string
}

export default function MainMenu({ className }: Props) {
  return (
    <div className={className}>
      <MainMenuItem
        text="Dashboard"
        link={dashboard_path(":index")}
        icon={<CircleGauge size={20} />}
      />
      <MainMenuItem
        text="Organizations"
        link={org_path(":index")}
        icon={<Building size={20} />}
      />
      <MainMenuItem text="Contacts" link={contact_path(":index")} icon={<Users size={20} />} />
      <MainMenuItem text="Reports" link={report_path(":index")} icon={<Printer size={20} />} />
    </div>
  )
}
